#!/bin/bash

mkdir -p id ad

wget -q 'http://www.spritpreismonitor.de/suche/?tx_spritpreismonitor_pi1[searchRequest][plzOrtGeo]=hamburg&tx_spritpreismonitor_pi1[searchRequest][umkreis]=20&tx_spritpreismonitor_pi1[searchRequest][kraftstoffart]=diesel&tx_spritpreismonitor_pi1[searchRequest][tankstellenbetreiber]=' -O - |
grep 'var spmResult' |
tr '{}' '\n' |
sed -e 's/^"//' -e 's/":"/="/g' -e 's/,"/      /g' |
grep name= |
while read l ; do
    eval $l
    grep -q "$datum $diesel" id/$mtsk_id  2> /dev/null || {
	echo "$datum $diesel" >> id/$mtsk_id
	echo "$l" | sed 's/"  */"@/g' | tr @ '\012' > ad/$mtsk_id
    }
done
