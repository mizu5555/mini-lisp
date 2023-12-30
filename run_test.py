import os
import re

def atoi(text):
    return int(text) if text.isdigit() else text

def natural_keys(text):
    return [ atoi(c) for c in re.split(r'(\d+)', text) ]

for r, d, files in os.walk("public_test_data"):
    files.sort(key=natural_keys)
    for file in files:
        print(file)
        os.system('./final < public_test_data/' + file)
        print("\n--------------------------")