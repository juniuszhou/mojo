def show_type[T: AnyType]():
    # get type info at the runtime
    comptime type_name = reflect[T].name()
    comptime field_count = reflect[T].field_count()
    comptime field_names = reflect[T].field_names()
    comptime field_types = reflect[T].field_types()

    print("struct", type_name)

    comptime for idx in range(field_count):
        comptime field_name = field_names[idx]
        comptime field_type = reflect[field_types[idx]].name()
        var intro = "├──" if idx < (field_count - 1) else "└──"
        print(intro, " var ", field_name, ": ", field_type, sep="")


@fieldwise_init
struct MyStruct:
    var x: String
    var y: Optional[Int]


comptime DefaultItemCount = 10


struct ParameterizedStruct[
    T: Movable & Deinitable, item_count: Int = DefaultItemCount
]:
    var list: List[Self.T]

    def __init__(out self):
        self.list = List[Self.T](capacity=Self.item_count)


def main():
    show_type[MyStruct]()
    print()
    show_type[Optional[Float64]]()
    print()
    show_type[Dict[Int, String]]()
    print()
    show_type[ParameterizedStruct[String, item_count=5]]()
