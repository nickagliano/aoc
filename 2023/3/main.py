def part_one(filename):
    with open(filename, "r") as f:
        grid = f.readlines()

        sum = 0

        y = 0
        for row in grid:
            row = row.strip()
            row = [char for char in row]
            x = 0

            finding_number = False
            number = ""

            for char in row:
                if char.isdigit():
                    if finding_number:
                        number += char

                        # if found end of row, check if number is adjacent to symbol
                        if x + 1 == len(row):
                            start_x = x - len(number) + 1

                            if is_adjacent_to_symbol(grid, start_x, y, len(number)):
                                sum += int(number)
                    else:
                        finding_number = True
                        number = char
                else:
                    if finding_number:
                        finding_number = False

                        start_x = x - len(number)

                        # if found the end of a number, check if number is adjacent to symbol
                        if is_adjacent_to_symbol(grid, start_x, y, len(number)):
                            sum += int(number)

                x += 1
            y += 1

        print(sum)


# Takes the grid, and x and y coord of the start of a number, and how long the number is
# Checks to see if number to left, right, up, or down, or diagonal is a symbol (is not a digit or a period)
def is_adjacent_to_symbol(grid, x, y, length):
    # Check diagonals if at the beginning or end of number
    if is_symbol(grid, x + length, y + 1):
        return True
    if is_symbol(grid, x - 1, y - 1):
        return True
    if is_symbol(grid, x + length, y - 1):
        return True
    if is_symbol(grid, x - 1, y + 1):
        return True

    # check to left
    if is_symbol(grid, x - 1, y):
        return True

    # check to right
    if is_symbol(grid, x + length, y):
        return True

    # iterate through length of number, checking above and below
    for i in range(length):
        if is_symbol(grid, x + i, y + 1):
            return True
        if is_symbol(grid, x + i, y - 1):
            return True

    return False


def is_symbol(grid, x, y):
    if x < 0 or y < 0:
        return False

    if x >= len(grid[0]) - 1 or y >= len(grid) - 1:
        return False

    if grid[y][x] == ".":
        return False

    if grid[y][x].isdigit():
        return False

    return True


def is_star(grid, x, y):
    if x < 0 or y < 0:
        return False

    if x >= len(grid[0]) - 1 or y >= len(grid) - 1:
        return False

    if grid[y][x] == "*":
        return True

    return False


def is_adjacent_to_star(grid, x, y, length):
    # Check diagonals if at the beginning or end of number
    if is_star(grid, x + length, y + 1):
        return x + length, y + 1
    if is_star(grid, x - 1, y - 1):
        return x - 1, y - 1
    if is_star(grid, x + length, y - 1):
        return x + length, y - 1
    if is_star(grid, x - 1, y + 1):
        return x - 1, y + 1

    # check to left
    if is_star(grid, x - 1, y):
        return x - 1, y

    # check to right
    if is_star(grid, x + length, y):
        return x + length, y

    # iterate through length of number, checking above and below
    for i in range(length):
        if is_star(grid, x + i, y + 1):
            return x + i, y + 1
        if is_star(grid, x + i, y - 1):
            return x + i, y - 1

    return False


def found_a_digit(grid, x, y):
    if x < 0 or y < 0:
        return False

    if x >= len(grid[0]) or y >= len(grid):
        return False

    if grid[y][x].isdigit():
        return True

    return False


def find_entire_number(grid, x, y):
    number = grid[y][x]  # initialize number with first found digit

    # look to left
    local_x = x - 1
    while found_a_digit(grid, local_x, y):
        # Prepend to number if it is a number (since we are going backwards)
        number = grid[y][local_x] + number
        local_x -= 1

    num_start_x = local_x + 1

    # look to right
    local_x = x + 1
    while found_a_digit(grid, local_x, y):
        # append to number if it is a number (since we are going forwards)
        number = number + grid[y][local_x]
        local_x += 1

    num_end_x = local_x - 1

    return number, num_start_x, num_end_x


def find_adjacent_numbers(grid, x, y):
    numbers_dict = {}

    # Check top right
    if found_a_digit(grid, x + 1, y - 1):
        num, start_x, end_x = find_entire_number(grid, x + 1, y - 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check above (make sure these aren't overlapping with top right and top left)
    if found_a_digit(grid, x, y - 1):
        num, start_x, end_x = find_entire_number(grid, x, y - 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check top left
    if found_a_digit(grid, x - 1, y - 1):
        num, start_x, end_x = find_entire_number(grid, x - 1, y - 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check bottom left
    if found_a_digit(grid, x - 1, y + 1):
        num, start_x, end_x = find_entire_number(grid, x - 1, y + 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check below (make sure these aren't overlapping with bottom right and bottom left)
    if found_a_digit(grid, x, y + 1):
        num, start_x, end_x = find_entire_number(grid, x, y + 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check bottom right
    if found_a_digit(grid, x + 1, y + 1):
        num, start_x, end_x = find_entire_number(grid, x + 1, y + 1)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check to left
    if found_a_digit(grid, x - 1, y):
        num, start_x, end_x = find_entire_number(grid, x - 1, y)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    # Check to right
    if found_a_digit(grid, x + 1, y):
        num, start_x, end_x = find_entire_number(grid, x + 1, y)

        if num:
            if num not in numbers_dict.keys():
                numbers_dict[num] = [[start_x, end_x]]
            else:
                numbers_dict[num].append([start_x, end_x])

    return numbers_dict


def remove_duplicates_and_convert_to_array(numbers_dict):
    array = []

    if not numbers_dict:
        return array

    for key in numbers_dict.keys():
        # Remove duplicates from list
        numbers_dict[key] = set(map(tuple, numbers_dict[key]))

        # Append the key x number of times to array, based on how big the list is
        array += [key] * len(numbers_dict[key])

    return array


def part_two(filename):
    with open(filename, "r") as f:
        rows = f.readlines()

    rows = [row.strip() for row in rows]

    sum = 0
    grid = []

    for row in rows:
        grid.append([char for char in row])

    y = 0
    for row in grid:
        x = 0
        for char in row:
            if char == "*":
                numbers_dict = find_adjacent_numbers(grid, x, y)
                numbers_array = remove_duplicates_and_convert_to_array(numbers_dict)

                if len(numbers_array) == 2:
                    sum += int(numbers_array[0]) * int(numbers_array[1])
            x += 1
        y += 1

    print(sum)


if __name__ == "__main__":
    # part_one('sample.txt')
    # part_one('input.txt')
    part_two("sample.txt")
    part_two("input.txt")
