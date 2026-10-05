# since 1.1.0, Movable is supported for structs as default
# you can disable it by using the where False clause
struct Person(Movable where False):  # false means the trait is not implemented
    var name: String
    var age: Int

    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    def __deinit__(deinit self):
        pass


# you can use the Writable trait to print the struct
struct Person2(Writable):
    var name: String
    var age: Int

    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    def __deinit__(deinit self):
        pass


# you can use the Writable trait to print the struct
struct Person3(Copyable, ImplicitlyCopyable):
    var name: String
    var age: Int

    # constructor with parameters
    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    # copy constructor
    def __init__(out self, *, copy: Self):
        self.name = copy.name
        self.age = copy.age

    def __deinit__(deinit self):
        pass


def main():
    # var person: Person = Person(name="John", age=20)
    # var b = person^  # move the person to the heap
    # print(b.name, b.age)

    var person2: Person2 = Person2(name="John", age=20)
    print(person2)

    var person3: Person3 = Person3(name="John", age=20)
    # implicitly copy the person3 to the person4
    var person4 = person3
    # explicitly copy the person3 to the person5
    var person5 = person3.copy()
    # print the person4 and person5
    print(person4.name, person5.age)
