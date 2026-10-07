"""从 Python 调用 Mojo 代码的两种演示方式。

Mojo 侧模块: ``packages/sample_module.mojo``。

该 Mojo 文件通过 ``PythonModuleBuilder`` 注册了三个函数给 Python::

    sample_module.add(a, b)        # 整数加法, 返回 Int
    sample_module.greet(name)      # 字符串问候, 返回 String
    sample_module.sample_function()  # 无参数, 打印一句话, 返回 None

其导出入口为 ``PyInit_sample_module`` (符号名必须与文件名一致),
CPython 运行时正是通过这个 C ABI 入口来加载扩展模块的。

两种 Python 侧调用方式对比:

| 方式 | 函数 | 原理 | 适用场景 |
|------|------|------|----------|
| 扩展自动编译导入 | :func:`call_mojo_via_lib` | ``import mojo.importer`` 注册一个 meta-path finder, ``import sample_module`` 时自动调用 ``mojo build`` 编译并缓存到 ``__mojocache__/`` | 开发调试、最简 demo |
| C API 手动加载共享库 | :func:`call_mojo_via_c_api` | 先执行 ``mojo build --emit shared-lib`` 得到 ``.so``, 再用 ``importlib`` 经 CPython C API (``PyInit_sample_module``) 加载 | 生产部署、需要固定 ``.so`` 工件的场景 |

运行方式 (必须在 pixi 环境内, ``mojo`` 可执行文件由 pixi 提供)::

    pixi run -- python python/call_mojo.py
"""

from __future__ import annotations

import importlib.util
import shutil
import subprocess
import sys
from pathlib import Path

# 仓库根目录: <repo>/python/call_mojo.py -> <repo>
_REPO_ROOT = Path(__file__).resolve().parent.parent
# Mojo 包目录: <repo>/packages, 内含 sample_module.mojo
_MOJO_PACKAGE_DIR = _REPO_ROOT / "packages"
_MOJO_SOURCE = _MOJO_PACKAGE_DIR / "sample_module.mojo"
# C API 方式编译产物的默认落盘位置
_DEFAULT_SO = _REPO_ROOT / "python" / "sample_module.so"


def call_mojo_via_lib():
    """方式一: 经 ``mojo.importer`` 自动编译并导入 Mojo 扩展模块。

    原理
    ----
    1. ``import mojo.importer`` 向 ``sys.meta_path`` 注册 ``MojoImporter``。
    2. ``import sample_module`` 命中该 finder, 它在后台调用 ``mojo build``
       把 ``packages/sample_module.mojo`` 编译成共享库并缓存于
       ``__mojocache__/`` 目录。
    3. CPython 通过模块内的 ``PyInit_sample_module`` (``abi("C")``) 入口
       完成模块初始化, 之后即可像普通 Python 模块一样调用
       ``add / greet / sample_function``。

    前提
    ----
    - 运行在 pixi 环境中 (``pixi run -- python ...``), 保证 ``mojo`` 可用。
    - ``packages/sample_module.mojo`` 中 ``PyInit_<模块名>`` 的名字必须与
      文件名一致, 且文件中不能含 ``main()`` (共享库不允许有入口函数)。

    Returns:
        导入后的 ``sample_module`` 模块对象, 便于调用方复用。
    """
    sys.path.insert(0, str(_MOJO_PACKAGE_DIR))

    import mojo.importer  # noqa: F401  # 注册 MojoImporter, 必须先于 import sample_module
    import sample_module  # type: ignore[import-not-found]

    print("calling mojo from python", flush=True)
    print("add(1, 2) =", sample_module.add(1, 2), flush=True)
    print("greet('python') =", sample_module.greet("python"), flush=True)
    sample_module.sample_function()
    return sample_module


def call_mojo_via_c_api(so_path: str | Path | None = None, rebuild: bool = True):
    """方式二: 经 C API 手动编译共享库并用 ``importlib`` 加载。

    原理
    ----
    1. 调用 ``mojo build --emit shared-lib packages/sample_module.mojo
       -o sample_module.so`` 显式产出 CPython 扩展 (ELF 共享库)。
    2. 用 ``importlib.util.spec_from_file_location`` 从该 ``.so`` 创建
       module spec, CPython loader 会 ``dlopen`` 并查找其中的
       ``PyInit_sample_module`` C 符号完成初始化 —— 这就是“经由 C API”
       的含义。
    3. 之后调用方式与方式一完全相同。

    与方式一的区别在于编译时机由调用方显式控制 (可做缓存/版本管理/
    分发 ``.so``), 不依赖 ``mojo.importer`` 的隐式编译。

    Args:
        so_path: ``.so`` 产物的落盘路径, 默认为 ``python/sample_module.so``。
        rebuild: 为 True (默认) 时, 若 ``.so`` 不存在或比 ``.mojo`` 源码旧
            则自动重新编译; 为 False 时直接加载现有 ``.so``。

    Returns:
        加载后的 ``sample_module`` 模块对象, 便于调用方复用。
    """
    dest = Path(so_path) if so_path is not None else _DEFAULT_SO

    if rebuild and _needs_rebuild(dest):
        _build_shared_lib(dest)

    print("calling mojo from python via c api", flush=True)
    spec = importlib.util.spec_from_file_location("sample_module", str(dest))
    if spec is None or spec.loader is None:
        raise ImportError(f"无法从 {dest} 创建 module spec, 请确认 .so 已正确编译")
    module = importlib.util.module_from_spec(spec)
    # 注册到 sys.modules, 使 Mojo 侧异常回溯 / 子模块引用行为与常规 import 一致
    sys.modules["sample_module"] = module
    spec.loader.exec_module(module)

    print("add(1, 2) =", module.add(1, 2), flush=True)
    print("greet('python') =", module.greet("python"), flush=True)
    module.sample_function()
    return module


def _needs_rebuild(so_path: Path) -> bool:
    """判断共享库是否需要 (重新) 编译: 不存在或比 Mojo 源码旧即需编译。"""
    if not so_path.exists():
        return True
    return _MOJO_SOURCE.stat().st_mtime > so_path.stat().st_mtime


def _build_shared_lib(dest: Path) -> None:
    """执行 ``mojo build --emit shared-lib`` 产出 ``.so``。

    Raises:
        RuntimeError: 找不到 ``mojo`` 可执行文件时抛出
            (请用 ``pixi run -- python ...`` 运行)。
        subprocess.CalledProcessError: 编译失败时抛出。
    """
    mojo_bin = shutil.which("mojo")
    if mojo_bin is None:
        raise RuntimeError(
            "找不到 `mojo` 可执行文件, 请用 `pixi run -- python ...` 运行"
        )
    dest.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        mojo_bin,
        "build",
        "--emit",
        "shared-lib",
        str(_MOJO_SOURCE),
        "-o",
        str(dest),
    ]
    print("+", " ".join(cmd), flush=True)
    subprocess.run(cmd, check=True)


if __name__ == "__main__":
    call_mojo_via_lib()
    print("-" * 40, flush=True)
    call_mojo_via_c_api()
