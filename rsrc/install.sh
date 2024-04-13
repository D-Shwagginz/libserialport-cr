git clone git://sigrok.org/libserialport
sudo apt-get install autoconf
./libserialport/autogen.sh
./libserialport/configure.ac
sudo make -C libserialport
sudo make install -C libserialport

