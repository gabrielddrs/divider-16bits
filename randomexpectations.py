import random

BITS = 16  
TESTS_NUMBERS = 10 

def to_bin(value, width):
    return bin(value)[2:].zfill(width)

def calculate_division(dividend, divisor):
    if divisor == 0:
        quotient = 0
        remainder = dividend  
    else:
        quotient = dividend // divisor  
        remainder = dividend % divisor  
    return quotient, remainder

def main():
    testvectors = []

    for _ in range(TESTS_NUMBERS):
        dividend = random.randint(0, 2**BITS - 1)
        divisor = random.randint(1, 2**BITS - 1)  # Evitar divisor zero

        quotient, remainder = calculate_division(dividend, divisor)

        dividend_bin = to_bin(dividend, BITS)
        divisor_bin = to_bin(divisor, BITS)
        quotient_bin = to_bin(quotient, BITS)
        remainder_bin = to_bin(remainder, BITS)

        testvectors.append('_'.join([dividend_bin, divisor_bin, quotient_bin, remainder_bin]))

    with open('expectations.txt', 'w') as file:
        file.write('\n'.join(testvectors))

if __name__ == '__main__':
    main()
