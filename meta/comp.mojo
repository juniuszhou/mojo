def create_tensor[DType: DType, Rank: Int]():
    # DType 和 Rank 均属于 comptime 变量
    print("Creating tensor with rank:", Rank)


def optimize_algorithm[SIMD_WIDTH: Int]():
    # @parameter 告诉编译器这是一个编译期的条件判断
    @parameter
    if SIMD_WIDTH > 4:
        print("Using advanced AVX-512 optimization")
    else:
        print("Using basic fallback algorithm")


def main():
    # 1024 * 4 is a comptime constant, the evaluation is done at compile time
    comptime BUFFER_SIZE: Int = 1024 * 4
    print("Buffer size is:", BUFFER_SIZE)
