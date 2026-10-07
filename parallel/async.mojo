from std.async import async, await


def main() raises:
    var result = run("pwd")
    print(result)

    var args = argv()
    for arg in args:
        print(arg)
