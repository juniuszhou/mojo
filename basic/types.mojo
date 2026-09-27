from std.collections import List, Set, Optional, Dict


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
    var list: List[Float64] = [1.0, 2.0]
    var set: Set[Float64] = {1.0, 2.0}
    var map: Dict[String, Float64] = {"a": 1.0, "b": 2.0}
    var option: Optional[Float64] = Optional(1.0)

    if option:
        print("Option is some")
    else:
        print("Option is none")

    print(list)
    print(set)
    print(map)
    print(option)


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

    # SIMD vector
    var vec = SIMD[DType.float32, 4](3.0, 2.0, 2.0, 1.0)
    print(vec)

    comptime my = SIMD[DType.float32, length=1]
    comptime MyInt = Scalar[DType.int]
    comptime MyInt8 = Scalar[DType.int8]
    comptime MyFloat32 = Scalar[DType.float32]
