struct Person(Copyable, Writable):
    var name: String
    var age: Int

    def __init__(out self, name: String, age: Int):
        self.name = name
        self.age = age

    def print(self):
        print(self.name, self.age)


def copy_transfer():
    var name: String = "John"

    var copied_name = name
    var transferred_name = name^
    print(copied_name)
    print(transferred_name)


def main() raises:
    copy_transfer()

    var person: Person = Person(name="John", age=20)
    var copied_person = person.copy()
    var transferred_person = person^
    print(copied_person)
    print(transferred_person)

    var items: List[Int] = [99, 77, 33, 12]

    var item = items[1]  # item is a copy of items[1]
    item += 1  # increments item
    print(items[1])  # prints 77
