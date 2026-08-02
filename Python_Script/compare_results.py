"""
This file compares the final Python results with the final RTL results.

Registers, RAM, IO1, and IO2 are checked separately.
"""

import os
import sys


# Use the folder containing this file as the working folder.
PYTHON_FOLDER = os.path.dirname(os.path.abspath(__file__))
os.chdir(PYTHON_FOLDER)


"""
Read every non-empty line from one result file.
"""
def read_result_file(filename):
    if not os.path.exists(filename):
        raise FileNotFoundError(f"Result file not found: {filename}")

    results = []

    with open(filename, "r", encoding="utf-8") as file:
        for line in file:
            line = line.strip()

            if line != "":
                results.append(line)

    return results


"""
Compare one Python result file with one RTL result file.
"""
def compare_files(name, python_filename, rtl_filename):
    python_results = read_result_file(python_filename)
    rtl_results = read_result_file(rtl_filename)

    passed = True
    number_of_lines = max(len(python_results), len(rtl_results))

    for index in range(number_of_lines):
        # Use "<missing>" when one file has fewer lines than the other.
        if index < len(python_results):
            python_line = python_results[index]
        else:
            python_line = "<missing>"

        if index < len(rtl_results):
            rtl_line = rtl_results[index]
        else:
            rtl_line = "<missing>"

        if python_line != rtl_line:
            passed = False

            print(
                f"{name}, line {index + 1}:\n"
                f"Python: {python_line}\n"
                f"RTL: {rtl_line}"
            )

    if passed:
        print(f"{name}: PASS")
    else:
        print(f"{name}: FAIL\n")

    return passed


"""
Compare registers, RAM, IO1, and IO2.
"""
def main():
    try:
        registers_passed = compare_files("Registers", "final_register_results_python.txt", "final_register_results_rtl.txt")

        memory_passed = compare_files("Memory", "final_memory_results_python.txt", "final_memory_results_rtl.txt")

        io1_passed = compare_files("IO1", "final_io1_results_python.txt", "final_io1_results_rtl.txt")

        io2_passed = compare_files("IO2", "final_io2_results_python.txt", "final_io2_results_rtl.txt")

    except FileNotFoundError as error:
        print(f"COMPARISON ERROR: {error}")
        return 1

    if (registers_passed and memory_passed and io1_passed and io2_passed):
        print("\nFINAL RESULT: PASS")
        return 0

    print("\nFINAL RESULT: FAIL")
    return 1


if __name__ == "__main__":
    sys.exit(main())
