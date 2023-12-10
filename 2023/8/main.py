import math


# recursive function
def navigate(map, directions, start, num_steps):
    key = start

    for direction in directions:
        num_steps += 1
        left, right = map[key]

        if direction == "L":
            key = left
            end = left
        elif direction == "R":
            key = right
            end = right
        else:
            raise ValueError("Invalid direction encountered")

        # base case
        if end == "ZZZ":
            return num_steps, end

    steps, end = navigate(map, directions, end, num_steps)

    return steps, end


def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    map = {}

    for i, line in enumerate(lines):
        if i == 0:
            directions = line.split(" ")[0]
            continue

        # if line is blank, skip
        if line == "":
            continue

        splits = line.split(" = ")

        key = splits[0]
        left = splits[1].split(", ")[0]
        left = left[1:]
        right = splits[1].split(", ")[1]
        right = right[:-1]
        map[key] = (left, right)

    start = "AAA"
    steps = 0

    while steps == 0:
        steps, start = navigate(map, directions, start, steps)

    print(steps)


def find_starting_nodes(map):
    starting_nodes = []

    for key, _value in map.items():
        if key[-1] == "A":
            starting_nodes.append(key)

    return starting_nodes


def navigate_part_two(map, directions, start, num_steps):
    key = start

    for direction in directions:
        num_steps += 1

        left, right = map[key]

        if direction == "L":
            key = left
            end = left
        elif direction == "R":
            key = right
            end = right
        else:
            raise ValueError("Invalid direction encountered")

        if end[-1] == "Z":
            return num_steps, end
        else:
            key = end

    num_steps, key = navigate_part_two(map, directions, key, num_steps)

    return num_steps, key


def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    map = {}

    for i, line in enumerate(lines):
        if i == 0:
            directions = line.split(" ")[0]
            continue

        # if line is blank, skip
        if line == "":
            continue

        splits = line.split(" = ")

        key = splits[0]
        left = splits[1].split(", ")[0]
        left = left[1:]
        right = splits[1].split(", ")[1]
        right = right[:-1]
        map[key] = (left, right)

    starting_nodes = find_starting_nodes(map)

    step_array = []

    for start in starting_nodes:
        steps = 0

        while steps == 0:
            steps, start = navigate_part_two(map, directions, start, steps)
        step_array.append(steps)

    print(step_array)
    lcm = math.lcm(*step_array)
    print(lcm)


if __name__ == "__main__":
    part_one("part_one_sample.txt")  # 2
    part_one("part_one_other_sample.txt")  # 6
    part_one("input.txt")  # 14681
    part_two("part_two_sample.txt")  # 6
    part_two("input.txt")  # 14321394058031
