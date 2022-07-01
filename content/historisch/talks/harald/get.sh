#!/bin/bash

mkdir -p id

wget -q 'http://www.spritpreismonitor.de/suche/?tx_spritpreismonitor_pi1[searchRequest][plzOrtGeo]=hamburg&tx_spritpreismonitor_pi1[searchRequest][umkreis]=20&tx_spritpreismonitor_pi1[searchRequest][kraftstoffart]=diesel&tx_spritpreismonitor_pi1[searchRequest][tankstellenbetreiber]=' -O - |
grep 'var spmResult'  |
sed 's/","/",\n"/g' |
tr '{}' '\n' |
sed  's/":"/ /'  |
tr -d '"' |
sed -e 's/,$//' -e  1d  |
while read key val  ; do
    case $key in
	datum) datum="$val" ;;
 mtsk_id) id=$val ;;
 diesel) { [ -r id/$id ] && grep -q "$datum $val" id/$id ; }  ||
	    echo $datum $val >> id/$id ;;
    esac
done
