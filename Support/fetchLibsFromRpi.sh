#!/bin/bash
set -euo pipefail

: ${RPI_USER:="pi"}
: ${RPI_HOST:="10.0.1.130"}

RPI_SSH="${RPI_USER}@${RPI_HOST}"

TEMPORARY="$(mktemp -dt "$(basename "$0").XXXXXXXXXX")"

echo "Fetching /usr components from RPI."
mkdir -p ${TEMPORARY}/usr/{lib,include}
rsync -haP ${RPI_SSH}:/usr/lib/ ${TEMPORARY}/usr/lib/
rsync -haP ${RPI_SSH}:/usr/include/ ${TEMPORARY}/usr/include/

echo "Fetching /lib components from RPI."
mkdir -p ${TEMPORARY}/lib
rsync -haP ${RPI_SSH}:/lib/ ${TEMPORARY}/lib/

echo "Fetching /opt/vc components from RPI."
mkdir -p ${TEMPORARY}/opt/vc
rsync -haP ${RPI_SSH}:/opt/vc/ ${TEMPORARY}/opt/vc/

echo "Compressing components to archive."
tar -c -C "${TEMPORARY}" .|pv -c -s "$(du -sb "${TEMPORARY}" | awk '{print $1}')" -N "Uncompressed"|gzip -c|pv -cW -N "Compressed" >usr-lib-rpi.tar.gz

echo Cleaning up temporary storage.
# Clean up temporary storage
if [ -d "${TEMPORARY}" ]; then
    rm -rf "${TEMPORARY}"
fi
