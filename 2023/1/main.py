def part_one(filename):
    lines = []

    with open(filename, "r") as f:
        lines = [line.strip() for line in f.readlines()]

    sum = 0

    for line in lines:
        line = line.strip()
        first_digit = None
        last_digit = None

        for char in line:
            if char.isdigit():
                if first_digit is None:
                    first_digit = char

                last_digit = char

        if first_digit is not None and last_digit is not None:
            sum += int(first_digit + last_digit)

    print(sum)


def solve_line(line):
    digits = []
    words_array = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    ]

    for i, char in enumerate(line):
        if char.isdigit():
            digits.append(char)
        for j, word in enumerate(words_array):
            # Where the magic happens
            if line[i:].startswith(word):
                digits.append(str(j + 1))

    return digits


def part_two(filename):
    with open(filename, "r") as f:
        lines = [line.strip() for line in f.readlines()]

    sum = 0

    for line in lines:
        digits = solve_line(line)

        if digits:
            sum += int(digits[0] + digits[-1])

    print(sum)


if __name__ == "__main__":
    part_one("sample.txt")
    part_one("input.txt")
    part_two("sample_part_two.txt")  # Answer, 281
    part_two("input.txt")  # Answer, 53268
