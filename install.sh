#!/bin/bash

TEMP_DIR=/tmp

case `uname -m`  in
    aarch64)
        arch="linux-arm64"
    ;;
    mips)
        arch="linux-mips"
    ;;
    mipsel)
        arch="linux-mipsle"
    ;;
    arm64)
        arch="linux-arm64"
    ;;
    *)
        echo $(uname -m)" not suppoted"
        exit
    ;;
esac
BASE_URL="https://github.com/xvzc/SpoofDPI/releases/latest/download"
FILENAME="spoofdpi-${arch}.tar.gz"

FILE_URL="${BASE_URL}/${FILENAME}"

if curl --output /dev/null --silent --head --fail "$FILE_URL"; then
    echo "Downloading ${FILENAME}..."
    (cd $TEMP_DIR && curl -L -O "$FILE_URL")
    echo "Binary ${FILENAME} successful downloaded."
else
    echo "Binary ${FILENAME} not found."
fi

tar -xzf $TEMP_DIR/spoofdpi-${arch}.tar.gz && \
    rm -rf $TEMP_DIR/spoofdpi-${arch}.tar.gz && \
    mv ./spoofdpi /bin/spoofdpi && \
    chmod +x /bin/spoofdpi

if [ $? -ne 0 ]; then
    echo "Error. exiting now"
    exit
fi

curl -L "https://raw.githubusercontent.com/luvvvdev/spoofdpi-openwrt/refs/heads/main/etc/init.d/spoofdpi" -o /etc/init.d/spoofdpi
chmod +x /etc/init.d/spoofdpi

mkdir /etc/spoofdpi
curl -L "https://raw.githubusercontent.com/luvvvdev/spoofdpi-openwrt/refs/heads/main/etc/spoofdpi/spoofdpi.conf" -o /etc/spoofdpi/spoofdpi.conf

echo " "
echo "Successfully installed SpoofDPI"
