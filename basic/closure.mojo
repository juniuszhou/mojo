# thin emphasizes that the function is not a closure, it not use any variables from the outer scope.
def call(f: def(x: Int) thin -> Int, x: Int) -> Int:
    return f(x)


def main():
    var multiplier = 3

    # closure is a function that captures the environment of the function
    def scale(x: Int) {imm multiplier} -> Int:
        return x * multiplier

    print(scale(5))  # 15

    multiplier = 4
    print(scale(5))  # 20

    # lambda is a anonymous function, it is a function that is defined without a name.
    var increment = lambda (x: Int) -> Int: x + 1
    print(increment(5))  # 6

    print(call(increment, 5))  # 6
