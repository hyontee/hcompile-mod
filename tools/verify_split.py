#!/usr/bin/env python3
"""Проверка разбивки: разворачивает #include "bykranin_src/..." из gamemodes/bykranin.pwn
и (по желанию) сравнивает результат с исходным цельным файлом.

  python tools/verify_split.py gamemodes/bykranin.pwn [исходный_bykranin.pwn]

Ожидаемо: 7 отличающихся строк (см. README).
"""
import re, sys, os
main = sys.argv[1]
base = os.path.dirname(os.path.abspath(main))
SRC = 'bykranin_src'
def expand(path):
    out = []
    for l in open(path, 'rb').read().decode('latin-1').split('\n')[:-1]:
        if l.startswith('//>>'):
            continue
        m = re.match(r'^#include "' + SRC + r'/(.+)"\s*$', l)
        out += expand(os.path.join(base, SRC, m.group(1))) if m else [l]
    return out
got = expand(main)
print('строк после разворота:', len(got))
if len(sys.argv) > 2:
    ref = open(sys.argv[2], 'rb').read().decode('latin-1').split('\n')[:-1]
    diff = [(i + 1, a, b) for i, (a, b) in enumerate(zip(ref, got)) if a != b]
    print('строк в оригинале:', len(ref), '| отличий:', len(diff), '| длины равны:', len(ref) == len(got))
    for n, a, b in diff[:20]:
        print(f'  {n}: {a!r} -> {b!r}')
