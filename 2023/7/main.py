from math import lcm

cards = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
card_order = {
    "A": 0,
    "K": 1,
    "Q": 2,
    "J": 3,
    "T": 4,
    "9": 5,
    "8": 6,
    "7": 7,
    "6": 8,
    "5": 9,
    "4": 10,
    "3": 11,
    "2": 12,
}

cards_part_two = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
card_order_part_two = {
    "A": 0,
    "K": 1,
    "Q": 2,
    "T": 3,
    "9": 4,
    "8": 5,
    "7": 6,
    "6": 7,
    "5": 8,
    "4": 9,
    "3": 10,
    "2": 11,
    "J": 12,
}

# Types of hands
# - Five of a kind, where all five cards have the same label: AAAAA
# - Four of a kind, where four cards have the same label and one card has a different label: AA8AA
# - Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
# - Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
# - Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
# - One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
# - High card, where all cards' labels are distinct: 23456

hand_types = ["5oak", "4oak", "fh", "3oak", "2pair", "1pair", "1"]


def calculate_hand(hand):
    dict = {}

    for card in hand:
        if card in dict:
            dict[card] += 1
        else:
            dict[card] = 1

    if len(dict) == 1:  # 5oak
        return hand_types[0]

    if len(dict) == 2:  # 4oak or fh
        for key in dict:
            if dict[key] == 4:  # 4oak
                return hand_types[1]
        return hand_types[2]  # fh

    if len(dict) == 3:  # 3oak or 2pair
        for key in dict:
            if dict[key] == 3:
                return hand_types[3]  # 3oak
        return hand_types[4]  # 2pair

    if len(dict) == 4:  # 1pair
        return hand_types[5]

    if len(dict) == 5:  # 1 (high card)
        return hand_types[6]

    raise Exception(f"Invalid hand: {hand}")


# same as calculate_hand, but jokers can be wild cards
def calculate_hand_part_2(hand):
    dict = {}

    for card in hand:
        if card in dict:
            dict[card] += 1
        else:
            dict[card] = 1

    if len(dict) == 1:  # 5oak
        return hand_types[0]  # joker agnostic

    if len(dict) == 2:  # 5oak, 4oak, or fh
        if "J" in dict.keys():
            return hand_types[0]  # 5oak
        else:  # no jokers
            for key in dict:
                if dict[key] == 4:
                    return hand_types[1]  # 4oak

            return hand_types[2]  # fh

    if len(dict) == 3:
        if "J" in dict:
            if dict["J"] == 1:
                # if there are 3 of a kind, and 1 joker, then the joker can be used to make a 4oak
                for key in dict:
                    if dict[key] == 3:
                        return hand_types[1]  # 4oak
                # if there are 2 pairs, and 1 joker, then the joker can be used to make a fh
                return hand_types[2]  # fh
            elif dict["J"] == 2:
                return hand_types[1]  # always 4oak
            elif dict["J"] == 3:
                return hand_types[1]  # always 4oak
        else:  # no jokers
            for key in dict:
                if dict[key] == 3:
                    return hand_types[3]  # 3oak
            return hand_types[4]  # 2pair

    if len(dict) == 4:  # 4 types of cards, so always a 2 1 1 1 spread
        if "J" in dict:
            if dict["J"] == 1:
                return hand_types[3]  # 3oak
            elif dict["J"] == 2:
                return hand_types[3]  # 3oak
        else:
            return hand_types[5]  # 1pair

    if len(dict) == 5:
        if "J" in dict:
            return hand_types[5]  # 1pair
        else:
            return hand_types[6]  # 1 (high card)

    raise Exception(f"Invalid hand: {hand}")


def sort_types(ranks):
    for type in hand_types:
        ranks[type].sort(key=lambda x: [card_order[c] for c in x[0]])

    return ranks


def sort_types_part_two(ranks):
    for type in hand_types:
        ranks[type].sort(key=lambda x: [card_order_part_two[c] for c in x[0]])

    return ranks


def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    hands = []
    bids = []

    lines = [line.strip() for line in lines]

    for line in lines:
        splits = line.split(" ")
        if len(splits) != 2:
            raise Exception(f"Invalid line: {line}")
        hands.append(splits[0])
        bids.append(splits[1])

    ranks = {
        "5oak": [],
        "4oak": [],
        "fh": [],
        "3oak": [],
        "2pair": [],
        "1pair": [],
        "1": [],
    }

    for hand, bid in zip(hands, bids):
        hand_type = calculate_hand(hand)
        ranks[hand_type].append([hand, bid])

    sorted_ranks = sort_types(ranks)

    rank = 1
    winnings = 0

    # iterate backwards through ranks dictionary, starting with 1, ending with 5oak, and incrementing by 1 with each hand
    # doing so will find correct ranks for each hand
    for type in hand_types[::-1]:
        # iterate backwards in each array
        for hand in sorted_ranks[type][::-1]:
            winnings += int(hand[1]) * rank
            rank += 1

    print(winnings)


def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    hands = []
    bids = []

    for line in lines:
        splits = line.split(" ")
        if len(splits) != 2:
            raise Exception(f"Invalid line: {line}")
        hands.append(splits[0])
        bids.append(splits[1])

    ranks = {
        "5oak": [],
        "4oak": [],
        "fh": [],
        "3oak": [],
        "2pair": [],
        "1pair": [],
        "1": [],
    }

    for hand, bid in zip(hands, bids):
        hand_type = calculate_hand_part_2(hand)
        ranks[hand_type].append([hand, bid])

    sorted_ranks = sort_types_part_two(ranks)

    rank = 1
    winnings = 0

    # iterate backwards through ranks dictionary, starting with 1, ending with 5oak, and incrementing by 1 with each hand
    # doing so will find correct ranks for each hand
    for type in hand_types[::-1]:
        # iterate backwards in each array
        for hand in sorted_ranks[type][::-1]:
            winnings += int(hand[1]) * rank
            rank += 1

    print(winnings)


if __name__ == "__main__":
    part_one("sample.txt")  # 6440
    part_one("input.txt")  # 252052080
    part_two("sample.txt")  # 5905
    part_two("input.txt")  # 252898370
