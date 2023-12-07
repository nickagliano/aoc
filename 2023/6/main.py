def calculate_winning_times(time, distance):
    winning_times = []

    for i in range(1, time):
        dist = calculate_distance(i, time)

        if dist > distance:
            winning_times.append(i)

    return winning_times


def calculate_distance(hold_time, time):
    remaining_time = time - hold_time

    return hold_time * remaining_time


def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    times = []
    distances = []

    for i, line in enumerate(lines):
        if i == 0:  # parsing times
            times = line.split(" ")
            times.pop(0)
            times = [time for time in times if time != ""]
        elif i == 1:
            distances = line.split(" ")
            distances.pop(0)
            distances = [distance for distance in distances if distance != ""]

    counts = []

    for time, distance in zip(times, distances):
        winnings = calculate_winning_times(int(time), int(distance))
        counts += [len(winnings)]

    product = 1
    for count in counts:
        product *= count

    print(product)


def calculate_winning_times_part_two(time, distance):
    winning_times = []

    for i in range(1, time):
        dist = calculate_distance(i, time)

        if dist > distance:
            winning_times.append(i)

    return winning_times


def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    for i, line in enumerate(lines):
        if i == 0:  # parsing times
            times = line.split(" ")
            times.pop(0)
            times = [time for time in times if time != ""]
        elif i == 1:
            distances = line.split(" ")
            distances.pop(0)
            distances = [distance for distance in distances if distance != ""]

    # join times into one big time string
    time = "".join(times)

    # join distances into one big distance string
    distance = "".join(distances)

    result = calculate_winning_times_part_two(int(time), int(distance))
    print(len(result))


if __name__ == "__main__":
    part_one("sample.txt")
    part_one("input.txt")
    part_two("sample.txt") # 71503
    part_two("input.txt")  # Takes a while, but gets my correct answer, 20048741
