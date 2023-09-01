# A file used for automating the renaming process within each file

import sys
import re

if len(sys.argv) != 4:
    raise Exception('There should be exactly 3 args: target-file, the phrase to be replaced, and its replacement - not', {len(sys.argv)-1})

_, file_name, match, replacement = sys.argv
with open(file_name, 'r') as file:
    lines = file.readlines()

sub = lambda line: re.sub(match, replacement, line)
lines = [sub(line) for line in lines]

with open(file_name, 'w') as file:
    for line in lines:
        file.write(f'{line}')
