from std.collections import Optional


def main() raises:
    # prefix t for temporary string, it will be freed after the print.
    print(t"Hello, World!")
    var value = 10
    match value:
        case 10:
            print(t"value is 10")
        case 20:
            print(t"value is 20")
        case _:
            print(t"value is something else")

    var op = Optional(10)
    match op:
        case Optional.Some(value):
            print(t"value is {value}")
        case Optional.None:
            print(t"value is none")
