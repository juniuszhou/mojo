from std.collections import List, Set, Optional, Dict


def integers():
    var a: Int8 = 1
    var b: Int16 = 2
    var c: Int32 = 3
    var d: Int64 = 4
    var e: Int128 = 5
    var f: Int256 = 6

    var g: Int = 7
    var h: UInt8 = 8
    var i: UInt16 = 9
    var j: UInt32 = 10
    var k: UInt64 = 11
    var l: UInt128 = 12
    var m: UInt256 = 13

    print(a, b, c, d, e, f, g, h, i, j, k, l, m)


def floats():
    var a: Float16 = 1.0
    var b: Float32 = 2.0
    var c: Float64 = 3.0
    var d: BFloat16 = 4.0
    var e: Float4_e2m1fn = 5.0  # GPU only
    var f: Float8_e5m2 = 6.0  # GPU only
    var g: Float8_e4m3fn = 7.0  # GPU only
    print(a, b, c, d, e, f, g)


def immutable_usage():
    comptime MyInt = Int
    # immutable usage, use comptime variable as an immutable value
    # MyInt = 100
    # print(MyInt)


def ref_usage():
    var list: List[Float64] = [1.0, 2.0]
    ref item = list[0]
    item = 10.0
    print(list)


def collections():
    var array: Array[Float64, 2] = [1.0, 2.0]
    var list: List[Float64] = [1.0, 2.0]
    var set: Set[Float64] = {1.0, 2.0}
    var map: Dict[String, Float64] = {"a": 1.0, "b": 2.0}
    var tuple: Tuple[Float64, Float64] = (1.0, 2.0)
    var option: Optional[Float64] = Optional(1.0)

    if option:
        print("Option is some")
    else:
        print("Option is none")

    print(array, list, set, map, tuple, option)


def main() raises:
    var name: String = "John"
    var age: Int = 20
    var isStudent: Bool = True
    var height: Float16 = 1.75
    var weight: Float32 = 70.5
    var pi: Float64 = 3.14159265358979323846

    print("Hello, World!")
    print(name)
    print(age)
    print(isStudent)
    print(height)
    print(weight)
    print(pi)

    # SIMD vector, it will be in the same SIMD register, so it will be faster.
    var vec = SIMD[DType.float32, 4](3.0, 2.0, 2.0, 1.0)
    print(vec)

    # define type alias for SIMD vector with length 1. so we can get the real type during compile time.
    comptime my = SIMD[DType.float32, length=1]
    # Scalar is the SIMD with length 1.
    comptime MyInt = Scalar[DType.int]
    comptime MyInt8 = Scalar[DType.int8]
    comptime MyFloat32 = Scalar[DType.float32]
