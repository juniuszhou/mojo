def parameter_passing(
    value: Int,  # immutable value
    mut value2: Int,  # mutable value
    ref value3: Int,  # reference to a value
    var value4: Int,  # pass by value
) -> Int:
    # value = 10
    value2 = 20
    # value3 = 30
    value4 = 40
    return value + value2 + value3 + value4


struct Person:
    var name: String
    var age: Int

    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    def __deinit__(deinit self):
        pass


# keyword only arguments behind the *
def key_value_call(*, key: String, value: Int) -> Int:
    return value


def main():
    print("Hello, World!")

    def add(a: Int, b: Int) -> Int:
        return a + b

    print(add(1, 2))

    def add_with_default(a: Int, b: Int = 1) -> Int:
        return a + b

    print(add_with_default(1))

    def compare(a: Int, b: Int) -> Bool:
        return a >= b

    var value = 1
    var value2 = 2
    var value3 = 3
    var value4 = 4
    print(parameter_passing(value, value2, value3, value4))

    print(value, value2, value3, value4)

    print(key_value_call(key="a", value=1))
