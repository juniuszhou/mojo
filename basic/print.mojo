def main() raises:
    # prefix t for temporary string, it will be freed after the print.
    print(t"Hello, World!")

    var array = [1, 2, 3, 4, 5]
    for index in range(array.length):
        # {} is the placeholder for the variable, it will be replaced with the value of the variable.
        # the variable will be converted to a string automatically.
        print(t"position = {index + 1}, value = {array[index]}")
