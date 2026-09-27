def calculate_average(temps: List[Float64]) raises -> Float64:
    if len(temps) == 0:
        raise Error("Temps is empty")
    var total: Float64 = 0.0
    for t in temps:
        total += t
    return total / Float64(len(temps))


def main() raises:
    var temps: List[Float64] = []
    try:
        var avg = calculate_average(temps)

        if avg > 25.0:
            print("Status: Hot week")
        elif avg > 20.0:
            print("Status: Comfortable week")
        else:
            print("Status: Cool week")
    except e:
        print("Error:", e)
    else:
        print("No error")
    finally:
        print("Finally")
