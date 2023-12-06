def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    dict = {}

    for line in lines:
        start, end = line.split(": ")

        game_id = int(start.split("Game ")[1])

        dict[game_id] = {}

        games = end.split("; ")

        for game in games:
            pulls = game.split(", ")

            for pull in pulls:
                num = int(pull.split(" ")[0])
                color = pull.split(" ")[1]

                if color not in dict[game_id]:
                    dict[game_id][color] = 0

                if num > dict[game_id][color]:
                    dict[game_id][color] = num 

    limits = {
        "red": 12,
        "green": 13,
        "blue": 14,
    }

    possible_games = []

    for game_id in dict:
        game = dict[game_id]

        possible = True

        for color in limits:
            if game[color] > limits[color]:
                possible = False

        if possible:
            possible_games.append(game_id)

    print(sum(possible_games))


def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    dict = {}

    for line in lines:
        start, end = line.split(": ")

        game_id = int(start.split("Game ")[1])

        dict[game_id] = {}

        games = end.split("; ")

        for game in games:
            pulls = game.split(", ")

            for pull in pulls:
                num = int(pull.split(" ")[0])
                color = pull.split(" ")[1]

                if color not in dict[game_id]:
                    dict[game_id][color] = num

                if num > dict[game_id][color]:
                    dict[game_id][color] = num

    sum = 0

    for game_id in dict:
        game = dict[game_id]

        prod = 1

        for key, val in game.items():
            prod *= val

        sum += prod

    print(sum)


if __name__ == "__main__":
    part_one("sample.txt")
    part_one("input.txt")
    part_two("sample.txt")
    part_two("input.txt")
