from std.subprocess import run
from std.sys import argv


def main() raises:
    var result = run("pwd")
    print(result)

    var args = argv()
    for arg in args:
        print(arg)
