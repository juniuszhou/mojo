def all_equal[
    T: Equatable & Copyable & Deinitable
](ref lhs: List[T], ref rhs: List[T]) -> Bool:
    if len(lhs) != len(rhs):
        return False

    for left, right in zip(lhs, rhs):
        if left != right:
            return False
    return True


def main():
    var list1: List[Int] = [1, 2, 3]
    var list2: List[Int] = [1, 2, 3]
    print(all_equal(list1, list2))
