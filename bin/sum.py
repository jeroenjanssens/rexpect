#!/usr/bin/env python3

numbers = []

while True:
    user_input = input("Enter a number: ")
    
    if user_input == "sum":
        print(f"The sum is: {sum(numbers)}")
        continue

    try:
        numbers.append(float(user_input))
    except ValueError:
        print("Please enter a valid number.")