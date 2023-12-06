def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    sum = 0

    for line in lines:
        id = line.split(": ")[0]  # like Card 1
        card = line.split(": ")[1]
        winners = card.split(" | ")[0]
        your_numbers = card.split(" | ")[1]

        winner_array = winners.split(" ")
        winner_array = list(filter(None, winner_array))

        your_numbers_array = your_numbers.split(" ")
        your_numbers_array = list(filter(None, your_numbers_array))

        # Get the matches between the two arrays
        matches = [x for x in winner_array if x in your_numbers_array]

        # The first match makes the card worth one point and each match after the first doubles the point value of that card.
        # So, if there are 3 matches, the card is worth 1(2)(2) = 6 points.
        if len(matches) > 0:
            sum += 1 * (2 ** (len(matches) - 1))

    print(sum)


def num_matches(winners_array, your_numbers_array):
    matches = [x for x in winners_array if x in your_numbers_array]
    return len(matches)


def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    sum = 0

    card_dict = {}

    for line in lines:
        id = line.split(": ")[0]
        card = line.split(": ")[1].strip()

        # remove multiple spaces (Like Card  1)
        id = " ".join(id.split())

        winners = card.split(" | ")[0]
        your_numbers = card.split(" | ")[1]

        winners_array = winners.split(" ")
        winners_array = list(filter(None, winners_array))

        your_numbers_array = your_numbers.split(" ")
        your_numbers_array = list(filter(None, your_numbers_array))

        card_dict[id] = {
            "winners": winners_array,
            "your_numbers": your_numbers_array,
            "count": 1,
            "matches": num_matches(winners_array, your_numbers_array),
        }

    # update counts based on matches
    i = 1
    for id, card in card_dict.items():
        for j in range(card_dict[id]["matches"]):
            offset = j + 1
            card_dict["Card " + str(i + offset)]["count"] += 1 * card["count"]

        i += 1

    # get sum of all counts in the dict
    sum = 0
    for id, card in card_dict.items():
        sum += card["count"]

    print(sum)


if __name__ == "__main__":
    # part_one('sample.txt')
    # part_one('input.txt')
    part_two("sample.txt")
    part_two("input.txt")
