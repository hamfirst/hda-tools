import subprocess
import os
import sys
import time

try:
    f = open(sys.argv[1], 'r')
except Exception as e:
    print(str(e))
    exit()

verbstrings = f.read().splitlines()

lastnode = ''
writestr = ''
lastwritestr = ''
lastline = ''


for i in range(0, len(verbstrings)):
    line = verbstrings[i]
    parts = line.split()

    if len(line) == 0 or line[0] == '#':
        continue

    if len(parts) < 5:
        continue

    if parts[0] != 'hda-verb' or parts[1] != '/dev/snd/hwC0D0' or parts[2] != '0x20':
        continue

    if parts[3] == '0x500':

        if len(writestr) != 0 and writestr != lastwritestr:

            shouldprint = len(lastline) != 0
            lastline += '{ %s }, ' % writestr

            if(shouldprint):
                print('\t\t' + lastline)
                lastline = ''

            lastwritestr = writestr
            for i in range(0, int(len(writestr) / 4)):
                str1 = writestr[i*4:i*4+2]
                str2 = writestr[i*4+2:i*4+4]
                #print('0x%s 0x%s' % (str1, str2))

        lastnode = parts[4]
        writestr = ""

        continue

    if parts[3].startswith('0x4'):
        if lastnode == "0x23":
            if len(writestr) > 0:
                writestr += ', '

            writestr += '0x'
            writestr += parts[3][3:]

            if len(parts[4]) == 3:
                writestr += '0'
            writestr += parts[4][2:]

        if lastnode != '0x23':
            part1 = parts[3][3:]
            part2 = parts[4][2:]

            if len(part2) == 1:
                part2 = '0' + part2

            if len(lastline) > 0:
                print('\t\t' + lastline)
                lastline = ''

            print('%s, 0x%s%s' % (lastnode, part1, part2))

            lastnode = hex(int(lastnode, 16) + 1)
        continue
