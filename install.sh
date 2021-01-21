LIB=/usr/lib/pmm
BIN=/usr/bin/pmm
sudo mkdir -p $LIB
sudo cp pmm.sh $BIN
for u in /home/*; do mkdir -p $u/.pmm; done
