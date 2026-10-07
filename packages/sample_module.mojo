from std.os import abort

from std.python import PythonObject
from std.python.bindings import PythonModuleBuilder


def add(a: Int, b: Int) -> Int:
    """Pure Mojo integer addition (core logic, callable from Mojo)."""
    return a + b


def greet(name: String) -> String:
    """Pure Mojo string greeting (core logic, callable from Mojo)."""
    return "Hello, " + name + " from Mojo!"


def sample_function():
    """Original demo function: prints a message from Mojo."""
    print("sample function from package!")


def py_add(a: PythonObject, b: PythonObject) raises -> PythonObject:
    """Python-bound wrapper for `add` (converts PythonObject <-> Int)."""
    var x = Int(py=a)
    var y = Int(py=b)
    return PythonObject(x + y)


def py_greet(name: PythonObject) raises -> PythonObject:
    """Python-bound wrapper for `greet` (converts PythonObject <-> String)."""
    var who = String(py=name)
    return PythonObject(greet(who))


def py_sample_function() raises -> PythonObject:
    """Python-bound wrapper for `sample_function` (no args, returns None)."""
    sample_function()
    return PythonObject(None)


@export
def PyInit_sample_module() abi("C") -> PythonObject:
    """CPython extension entry point.

    The symbol name `PyInit_<module>` must match the file name
    (`sample_module.mojo`) so both `mojo.importer` and
    `mojo build --emit shared-lib` can expose it to Python.
    """
    try:
        var m = PythonModuleBuilder("sample_module")
        m.def_function[py_add]("add")
        m.def_function[py_greet]("greet")
        m.def_function[py_sample_function]("sample_function")
        return m.finalize()
    except e:
        abort(String("failed to create module sample_module: ", e))
