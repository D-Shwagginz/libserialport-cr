git clone git://sigrok.org/libserialport

apt-get install make
apt-get install gcc
apt-get install libtool

cd libserialport
./autogen.sh
./configure
make
make install
cd ..

sudo rm -r ./libserialport