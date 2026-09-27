from std.python import Python
from std.python.numpy import copy_to_numpy_array


def main() raises:
    var temps: List[Float64] = [20.5, 22.3, 19.8, 25.1]
    var np = Python.import_module("numpy")
    var pytemps = copy_to_numpy_array(temps)
    var std_dev = np.std(pytemps)
    print("Temperature standard deviation:", std_dev)
