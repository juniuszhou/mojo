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
