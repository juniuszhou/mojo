from std.math import ceildiv
from std.sys import has_accelerator
from max.gpu.host import DeviceContext
from std.gpu import block_dim, block_idx, thread_idx


# GPU kernel: each thread processes one element.
def vector_add(
    a: Pointer[Float32, MutAnyOrigin],
    b: Pointer[Float32, MutAnyOrigin],
    c: Pointer[Float32, MutAnyOrigin],
    n: Int32,
):
    var i = Int32(block_idx.x * block_dim.x + thread_idx.x)
    if i < n:
        c[unsafe_offset=i] = a[unsafe_offset=i] + b[unsafe_offset=i]


def main() raises:
    comptime N = 1024
    comptime BLOCK = 256

    comptime if not has_accelerator():
        print("No compatible GPU found")
    else:
        var ctx = DeviceContext()
        print("Found GPU:", ctx.name())

        var a_dev = ctx.enqueue_create_buffer[DType.float32](N)
        var b_dev = ctx.enqueue_create_buffer[DType.float32](N)
        var c_dev = ctx.enqueue_create_buffer[DType.float32](N)

        _ = a_dev.enqueue_fill(1.0)
        _ = b_dev.enqueue_fill(2.0)

        comptime grid = ceildiv(N, BLOCK)
        ctx.enqueue_function[vector_add](
            a_dev.unsafe_ptr().as_unsafe_any_origin(),
            b_dev.unsafe_ptr().as_unsafe_any_origin(),
            c_dev.unsafe_ptr().as_unsafe_any_origin(),
            Int32(N),
            grid_dim=grid,
            block_dim=BLOCK,
        )

        with c_dev.map_to_host() as c_host:
            print("c[0] =", c_host[0], "(expected 3.0)")
            print("c[N-1] =", c_host[N - 1], "(expected 3.0)")
