LIB=/usr/lib/pmm
BIN=/usr/bin/pmm
sudo mkdir -p $LIB
sudo cp pmm.sh $BIN
sudo chmod +x $BIN
for u in /home/*; do
    uu=`echo $u | awk '{ print gensub(/\/home\//, "", 1) }' -`;
    mkdir -p $u/.pmm;
    chown $uu:$uu $u/.pmm
done
