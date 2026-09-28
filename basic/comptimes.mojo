trait Addable:
    def __add__(self, other: Self) -> Self:
        return self + other


def comptime_add[T: Comparable & Addable](a: T, b: T) -> T:
    return a + b


def main():
    comptime x = 3
    print(x)

    # comptime for = 编译期定次数和下标，循环体还是运行时执行。
    comptime for i in range(10):
        print(i)
