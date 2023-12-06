# Output map holds values like "source_type": {"dest_type": {"source_val": "dest_val", ...}, ...}
def update_output_map(output_map, input_dict, from_key, to_key):
    for dest, source, length in input_dict[f"{from_key}-to-{to_key}"]:
        if from_key not in output_map:
            output_map[from_key] = {}
        if to_key not in output_map[from_key]:
            output_map[from_key][to_key] = {}

        output_map[from_key][to_key][int(source)] = {
            "dest": int(dest),
            "length": int(length),
        }


def part_one(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    seeds = []

    mode = None
    input_dict = {}

    # Build input_dict
    for i, line in enumerate(lines):
        if i == 0:
            items = line.split(" ")
            seeds = items[1:]
            continue

        if line.find("map:") != -1:
            mode = line.split(" ")[0]  # set mode
        else:
            items = line.split(" ")
            items = list(filter(None, items))

            if len(items) > 0:
                if mode not in input_dict:
                    input_dict[mode] = [items]
                else:
                    input_dict[mode].append(items)

    output_map = {}

    # List of key pairs for mapping
    key_pairs = [
        ("seed", "soil"),
        ("soil", "fertilizer"),
        ("fertilizer", "water"),
        ("water", "light"),
        ("light", "temperature"),
        ("temperature", "humidity"),
        ("humidity", "location"),
    ]

    # Iterate through each key pair and update the output map
    for from_key, to_key in key_pairs:
        update_output_map(output_map, input_dict, from_key, to_key)

    # Output map holds values like "source_type": {"dest_type": {"source_val": "dest_val", ...}, ...}

    results = []

    for seed in seeds:
        seed = int(seed)
        result = seed

        # seed to soil
        for source, obj in output_map["seed"]["soil"].items():
            if seed >= int(source) and seed <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + seed - int(source)
                break

        # soil to fertilizer
        for source, obj in output_map["soil"]["fertilizer"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        # fertilizer to water
        for source, obj in output_map["fertilizer"]["water"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        # water to light
        for source, obj in output_map["water"]["light"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        # light to temperature
        for source, obj in output_map["light"]["temperature"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        # temperature to humidity
        for source, obj in output_map["temperature"]["humidity"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        # humidity to location
        for source, obj in output_map["humidity"]["location"].items():
            if result >= int(source) and result <= int(source) + (obj["length"] - 1):
                result = obj["dest"] + result - int(source)
                break

        results.append(result)

    print(min(results))


def map_seed_ranges(output_map, from_key, to_key, seed_ranges):
    mapped_ranges = []

    for seed_start, seed_end in seed_ranges:
        overlap_found = False

        # Debug: Check if the current range includes seed #82
        if 82 >= seed_start and 82 <= seed_end:
            print(f"Debug: Tracking seed #82 in range ({seed_start}, {seed_end})")

        for source, obj in output_map[from_key][to_key].items():
            source_start = int(source)
            source_end = source_start + obj["length"] - 1

            # Check for overlap between seed range and source range
            if seed_end < source_start or seed_start > source_end:
                continue

            overlap_found = True

            # Calculate the overlapping range
            overlap_start = max(seed_start, source_start)
            overlap_end = min(seed_end, source_end)

            # Debug: Check if the current range includes seed #82
            if 82 >= overlap_start and 82 <= overlap_end:
                print(
                    f"Debug: Seed #82 overlaps with source range ({source_start}, {source_end})"
                )

            # Map the overlapping range
            mapped_start = obj["dest"] + overlap_start - source_start
            mapped_end = obj["dest"] + overlap_end - source_start

            mapped_ranges.append((mapped_start, mapped_end))

        # If no overlap was found for this seed range, add it as-is
        if not overlap_found:
            mapped_ranges.append((seed_start, seed_end))

    # Sort and combine contiguous ranges
    mapped_ranges.sort()  # NOTE: This sort is important! Otherwise, the combined ranges will be wrong
    combined_ranges = []
    for start, end in mapped_ranges:
        if combined_ranges and combined_ranges[-1][1] + 1 >= start:
            combined_ranges[-1] = (
                combined_ranges[-1][0],
                max(combined_ranges[-1][1], end),
            )
        else:
            combined_ranges.append((start, end))

        # Debug: Check if the combined range includes seed #82
        if 82 >= start and 82 <= end:
            print(f"Debug: Seed #82 is in combined range ({start}, {end})")

    return combined_ranges


# Use seed ranges
def part_two(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    seed_ranges = []

    mode = None
    input_dict = {}

    # Build input_dict
    for i, line in enumerate(lines):
        if i == 0:
            items = line.split(" ")
            seeds = items[1:]
            seed_ranges = []

            ii = 0
            while ii < len(seeds):
                start = int(seeds[ii])
                length = int(seeds[ii + 1])
                seed_ranges.append((start, start + (length - 1)))
                ii += 2

            continue

        if line.find("map:") != -1:
            mode = line.split(" ")[0]  # set mode
        else:
            items = line.split(" ")
            items = list(filter(None, items))

            if len(items) > 0:
                if mode not in input_dict:
                    input_dict[mode] = [items]
                else:
                    input_dict[mode].append(items)

    output_map = {}

    # List of key pairs for mapping
    key_pairs = [
        ("seed", "soil"),
        ("soil", "fertilizer"),
        ("fertilizer", "water"),
        ("water", "light"),
        ("light", "temperature"),
        ("temperature", "humidity"),
        ("humidity", "location"),
    ]

    # Iterate through each key pair and update the output map
    for from_key, to_key in key_pairs:
        update_output_map(output_map, input_dict, from_key, to_key)

    for from_key, to_key in key_pairs:
        seed_ranges = map_seed_ranges(output_map, from_key, to_key, seed_ranges)

    minimum = float("inf")
    min_location = min([start for start, end in seed_ranges])
    minimum = min(minimum, min_location)
    print(minimum)


if __name__ == "__main__":
    # part_one("sample.txt")
    # part_one("input.txt")

    # FIXME: should return 46. This actually broke when solving part 2 with the real input, but I get the right answer for the final :shrug:
    part_two("sample.txt")
    # part_two("input.txt")  # Answer: 84206669
