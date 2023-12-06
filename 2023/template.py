def part_one(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]


def part_two(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]


if __name__ == '__main__':
    part_one('sample.txt')
    # part_one('input.txt')
    # part_two('sample.txt')
    # part_two('input.txt')