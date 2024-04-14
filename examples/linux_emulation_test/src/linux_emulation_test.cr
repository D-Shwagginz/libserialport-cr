require "libserialport-cr"

alias SP = SerialPort

# Set Port Names
PORT_NAMES = ["/dev/pts/0", "/dev/pts/1"]

# Example of how to send and receive data.

# Helper function for error handling.
def check(result : SP::Return)
  # For this example we'll just exit on any error by raising.

  case result
  when SP::Return::ErrArg
    raise "Error: Invalid argument."
  when SP::Return::ErrFail
    error_message = SP.last_error_message
    SP.free_error_message(error_message)
    puts "Error: Failed: #{String.new(error_message)}"
  when SP::Return::ErrSupp
    raise "Error: Not supported."
  when SP::Return::ErrMem
    raise "Error: Couldn't allocate memory."
  when SP::Return::Ok
  else
    return result
  end
end

# This example can be used with one or two ports. With one port, it
# will send data and try to receive it on the same port. This can be
# done by connecting a single wire between the TX and RX pins of the
# port.
#
# Alternatively it can be used with two serial ports connected to each
# other, so that data can be sent on one and received on the other.
# This can be done with two ports with TX/RX cross-connected, e.g. by
# a "null modem" cable, or with a pair of interconnected virtual ports,
# such as those created by com0com on Windows or tty0tty on Linux.

# Get the port names from the command line.
if (PORT_NAMES.size < 1 || PORT_NAMES.size > 2)
  puts "Usage: #{PORT_NAMES[0]} <port 1> [<port 2>]\n"
  exit -1
end
num_ports = PORT_NAMES.size
port_names = PORT_NAMES

# The ports we will use.
ports = [] of Pointer(SP::Port)
2.times do
  ports << Pointer(SP::Port).malloc
end

# Open and configure each port.
num_ports.times do |i|
  port = ports[i]

  puts "Looking for port #{port_names[i]}.\n"
  check(SP.get_port_by_name(port_names[i], pointerof(port)))

  puts "Opening port.\n"
  check(SP.open(port, SP::Mode::ReadWrite))

  puts "Setting port to 9600 8N1, no flow control.\n"
  check(SP.set_baudrate(port, 9600))
  check(SP.set_bits(port, 8))
  check(SP.set_parity(port, SP::Parity::None))
  check(SP.set_stopbits(port, 1))
  check(SP.set_flowcontrol(port, SP::FlowControl::None))

  ports[i] = port
end

# Now send some data on each port and receive it back.
num_ports.times do |tx|
  # Get the ports to send and receive on.
  rx = num_ports == 1 ? 0 : ((tx == 0) ? 1 : 0)
  tx_port = ports[tx]
  rx_port = ports[rx]

  # The data we will send.
  data = "Crystal Lang is the best"
  size = data.size

  # We'll allow a 1 second timeout for send and receive.
  timeout = 1000

  # On success, SP.blocking_write() and SP.blocking_read()
  # return the number of bytes sent/received before the
  # timeout expired. We'll store that result here.
  result = 0

  # Send data.
  name = SP.get_port_name(tx_port)
  name = String.new(name) if name != Pointer(UInt8).null
  puts "Sending '#{data}' (#{size} bytes) on port #{name}.\n",
    result = check(SP.blocking_write(tx_port, data, size, timeout))

  # Check whether we sent all of the data.
  if (result == size)
    puts "Sent #{size} bytes successfully.\n"
  else
    puts "Timed out, #{result}/#{size} bytes sent.\n"
  end

  # Allocate a buffer to receive data.
  buf = Pointer(UInt8).malloc(size + 1);

  # Try to receive the data on the other port.
  name = SP.get_port_name(rx_port)
  name = String.new(name) if name != Pointer(UInt8).null
  puts "Receiving #{size} bytes on port #{name}.\n"
  result = check(SP.blocking_read(rx_port, buf, size, timeout))

  # Check whether we received the number of bytes we wanted.
  if (result == size)
    puts "Received #{size} bytes successfully.\n"
  else
    puts "Timed out, #{result}/#{size} bytes received.\n"
  end

  # Check if we received the same data we sent.
  buf = String.new(buf) if buf != Pointer(UInt8).null
  puts "Received '#{buf}'.\n"
end

# Close ports and free resources.
num_ports.times do |i|
  check(SP.close(ports[i]))
  SP.free_port(ports[i])
end