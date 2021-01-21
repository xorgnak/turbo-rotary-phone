LIB=/usr/lib/pmm
BIN=/usr/bin/pmm
mkdir -p $LIB
cp pmm.sh $BIN
for u in /home/*; do mkdir -p $u/.pmm; done
