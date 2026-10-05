from std.memory import Pointer, OwnedPointer


def takes_ref[o: Origin](ref[o] s: String):
    print(s)


def origin_usage():
    var name: String = "John"
    takes_ref[(origin_of(name))](name)


def main() raises:
    var name: String = "John"
    var p: Pointer = Pointer(to=name)
    var op: OwnedPointer = OwnedPointer(name)
    # address of the pointer, and value for owned pointer
    print(p, op)

    print(p[], op[])
    print(name)

    origin_usage()
