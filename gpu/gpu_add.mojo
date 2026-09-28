from std.math import ceildiv
from std.sys import has_accelerator
from max.gpu import global_idx
from max.gpu.host import DeviceContext
from layout import TileTensor, row_major

comptime dtype = DType.float32
comptime N = 1024
comptime BLOCK = 256
comptime layout = row_major[N]()


# GPU kernel: each thread processes one element.
def vector_add(
    a: TileTensor[dtype, type_of(layout), MutAnyOrigin],
    b: TileTensor[dtype, type_of(layout), MutAnyOrigin],
    c: TileTensor[dtype, type_of(layout), MutAnyOrigin],
    n: Int32,
):
    comptime assert a.flat_rank == 1, "expected 1D tensor"
    comptime assert b.flat_rank == 1, "expected 1D tensor"
    comptime assert c.flat_rank == 1, "expected 1D tensor"
    var i = global_idx.x
    if i < Int(n):
        c[i] = a[i] + b[i]


def main() raises:
    # comptime check if there is a compatible GPU
    comptime if not has_accelerator():
        print("No compatible GPU found")
    else:
        var ctx = DeviceContext()
        print("Found GPU:", ctx.name())

        var a_buf = ctx.enqueue_create_buffer[dtype](N)
        var b_buf = ctx.enqueue_create_buffer[dtype](N)
        var c_buf = ctx.enqueue_create_buffer[dtype](N)

        a_buf.enqueue_fill(1.0)
        b_buf.enqueue_fill(2.0)

        var a = TileTensor(a_buf, layout)
        var b = TileTensor(b_buf, layout)
        var c = TileTensor(c_buf, layout)

        ctx.enqueue_function[vector_add](
            a,
            b,
            c,
            Int32(N),
            grid_dim=ceildiv(N, BLOCK),
            block_dim=BLOCK,
        )

        with c_buf.map_to_host() as c_host:
            var result = TileTensor(c_host, layout)
            print("c[0] =", result[0], "(expected 3.0)")
            print("c[N-1] =", result[N - 1], "(expected 3.0)")
