git clone git://sigrok.org/libserialport

apt-get install make
apt-get install gcc
apt-get install libtool

cd libserialport
./autogen.sh
./configure
make
make install
sudo cp ./.libs/libserialport.so.0 /usr/lib/libserialport.so.0
cd ..

sudo rm -r ./libserialport