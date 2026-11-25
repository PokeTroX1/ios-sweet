#!/bin/bash
set -e
for f in $(find . -name "IORPC.h"); do
  if grep -q "struct IORPC" "$f" && ! grep -q "kernelContent" "$f"; then
    python3 -c '
import sys, re
p = sys.argv[1]
s = open(p).read()
s2 = re.sub(r"(struct IORPC\s*\{[^}]*?)(};)", r"\1    void *kernelContent;\n\2", s, count=1, flags=re.S)
open(p, "w").write(s2)
print("Patched", p)
' "$f"
  fi
done
