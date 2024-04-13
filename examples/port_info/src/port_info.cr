require "libserialport-cr"

# Example of how to get information about a serial port.

# Set Port Names
PORT_NAMES = ["COM11"]

alias SP = SerialPort

# Get the port name from the command line.
if (PORT_NAMES.size != 1)
  puts "Usage: #{PORT_NAMES[0]} <port name>\n"
  exit -1
end
port_name = PORT_NAMES[0]

# A pointer to a struct SP::port, which will refer to
# the port found.
port = Pointer(SP::Port).null

puts "Looking for port #{port_name}.\n"

# Call SP.get_port_by_name() to find the port. The port
# pointer will be updated to refer to the port found.
result = SP.get_port_by_name(port_name, pointerof(port))

if (result != SP::Return::Ok)
  puts "SP.get_port_by_name() failed!\n"
  exit -1
end

# Display some basic information about the port.
name = SP.get_port_name(port)
name = String.new(name) if name != Pointer(UInt8).null
desc = SP.get_port_description(port)
desc = String.new(desc) if desc != Pointer(UInt8).null
puts "Port name: #{name}\n"
puts "Description: #{desc}\n"

# Identify the transport which this port is connected through,
# e.g. native port, USB or Bluetooth.
transport = SP.get_port_transport(port)

if (transport == SP::Transport::Native)
  # This is a "native" port, usually directly connected
  # to the system rather than some external interface.
  puts "Type: Native\n"
elsif (transport == SP::Transport::Usb)
  # This is a USB to serial converter of some kind.
  puts "Type: USB\n"

  # Display string information from the USB descriptors.
  puts "Manufacturer: #{SP.get_port_usb_manufacturer(port)}\n"
  puts "Product: #{SP.get_port_usb_product(port)}\n"
  puts "Serial: #{SP.get_port_usb_serial(port)}\n"

  # Display USB vendor and product IDs.
  usb_vid : Int32 = 0
  usb_pid : Int32 = 0
  SP.get_port_usb_vid_pid(port, pointerof(usb_vid), pointerof(usb_pid))
  puts "VID: #{usb_vid} PID: #{usb_pid}\n"

  # Display bus and address.
  usb_bus : Int32 = 0
  usb_address : Int32 = 0
  SP.get_port_usb_bus_address(port, pointerof(usb_bus), pointerof(usb_address))
  puts "Bus: #{usb_bus} Address: #{usb_address}\n"
elsif (transport == SP::Transport::Bluetooth)
  # This is a Bluetooth serial port.
  puts "Type: Bluetooth\n"

  # Display Bluetooth MAC address.
  puts "MAC: #{SP.get_port_bluetooth_address(port)}\n"
end

puts "Freeing port.\n"

# Free the port structure created by sp_get_port_by_name().
SP.free_port(port)

# Note that this will also free the port name and other
# strings retrieved from the port structure. If you want
# to keep these, copy them before freeing the port.
