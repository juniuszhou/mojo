# set constraints on the type parameters via where clause or assert
def pow2[n: Int](i: Int) -> Int where n >= 0:
    comptime assert n >= 0, "n must be greater than 0"

    # conditional compilation
    comptime if n % 2 == 0:
        return 0
    else:
        return i << n


def get_first[n: Int](i: Array[Int, n]) -> Int where n >= 2:
    comptime assert n >= 2, "n must be greater than 2"

    # access the element of the array with safe index access
    return i[1]


def main():
    print(pow2[2](2))
    print(get_first[3]([1, 2, 3]))
