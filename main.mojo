from std.io import print, input


def main() raises:
    print("Temperature Analyzer")
    print("Enter the temperature in Celsius: ")
    try:
        var name = String(input())
        print("Hello, ", name, "!")
    catch error:
        print("Error: ", error)
    finally:
        print("Thank you for using the temperature analyzer!")
