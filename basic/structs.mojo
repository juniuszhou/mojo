trait Printable(Writable):
    def print(self):
        print(self)

enum Gender(Copyable, Writable):
    case Male
    case Female
    case Other

struct Person(Copyable, Writable):
    var name: String
    var age: Int

    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    def __deinit__(deinit self):
        print("Deinit")

    def print(self):
        print(self.name, self.age)

    def add_age(mut self, age: Int):
        self.age += age

    def __add__(mut self, other: Person):
        self.name = self.name + " " + other.name
        self.age = self.age + other.age

    @staticmethod
    def static_method():
        print("Static method")


def main() raises:
    var person: Person = Person(name="John", age=20)
    print(person)
    person.print()
    Person.static_method()
    person.add_age(10)

    var person2: Person = Person(name="Jane", age=30)
    person + person2
    person.print()
