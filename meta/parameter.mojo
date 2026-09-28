def all_equal[
    T: Equatable & Copyable & Deinitable
](ref lhs: List[T], ref rhs: List[T]) -> Bool:
    if len(lhs) != len(rhs):
        return False

    for left, right in zip(lhs, rhs):
        if left != right:
            return False
    return True


def my_sort[
    # infer-only parameters
    dtype: DType,
    width: SIMDLength,
](
    # positional-only parameter
    values: SIMD[dtype, width],
    /,
    # positional-or-keyword parameter
    compare: def(Scalar[dtype], Scalar[dtype]) thin -> Int,
    *,
    # keyword-only parameter
    reverse: Bool = False,
) -> SIMD[dtype, width]:
    var out = values
    for i in range(1, Int(width)):
        var j = i
        while j > 0 and compare(out[j], out[j - 1]) < 0:
            var t = out[j]
            out[j] = out[j - 1]
            out[j - 1] = t
            j -= 1
    if reverse:
        var rev = SIMD[dtype, width]()
        for i in range(Int(width)):
            rev[i] = out[Int(width) - 1 - i]
        return rev
    return out


def main():
    var list1: List[Int] = [1, 2, 3]
    var list2: List[Int] = [1, 2, 3]
    print(all_equal(list1, list2))

    var values: SIMD[DType.int32, 4] = [1, 2, 3, 4]

    def cmp_int(a: Scalar[DType.int32], b: Scalar[DType.int32]) -> Int:
        if a < b:
            return -1
        elif a > b:
            return 1
        else:
            return 0

    var reverse: Bool = False
    print(my_sort[DType.int32, 4](values, compare=cmp_int, reverse=reverse))
    # print(sorted_values)
