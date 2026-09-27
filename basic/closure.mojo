def main():
    var multiplier = 3

    # closure is a function that captures the environment of the function
    def scale(x: Int) {imm multiplier} -> Int:
        return x * multiplier

    print(scale(5))  # 15

    multiplier = 4
    print(scale(5))  # 20
