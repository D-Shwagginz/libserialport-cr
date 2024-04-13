require "libserialport-cr"

# Set Port Names
PORT_NAMES = ["COM11"]

alias SP = SerialPort

# Example of how to wait for events on multiple ports.

# Helper function for error handling.
def check(result : SP::Return)
  # For this example we'll just exit on any error by raising.

  case result
  when SP::Return::ErrArg
    raise "Error: Invalid argument."
  when SP::Return::ErrFail
    error_message = SP.last_error_message
    SP.free_error_message(error_message)
    raise "Error: Failed: #{String.new(error_message)}"
  when SP::Return::ErrSupp
    raise "Error: Not supported."
  when SP::Return::ErrMem
    raise "Error: Couldn't allocate memory."
  when SP::Return::Ok
  else
    return result
  end
end

# Get the port names from the command line.
if (PORT_NAMES.size < 1)
  raise "Usage: #{PORT_NAMES[0]} <port name>...\n}"
end
num_ports = PORT_NAMES.size
port_names = PORT_NAMES

# The ports we will use.
ports_ptr = Pointer(SP::Port).malloc(num_ports * sizeof(SP::Port))
ports = pointerof(ports_ptr)

# The set of events we will wait for.
# struct sp_event_set *event_set
event_set_ptr = SP::EventSet.new
event_set = pointerof(event_set_ptr)
# Allocate the event set.
check(SP.new_event_set(pointerof(event_set)))

# Open and configure each port, and then add its RX event
# to the event set.
num_ports.times do |i|
  port = ports[i]

  puts "Looking for port #{port_names[i]}.\n"
  check(SP.get_port_by_name(port_names[i], pointerof(port)))

  puts "Opening port."
  check(SP.open(port, SP::Mode::Read))

  puts "Setting port to 9600 8N1, no flow control."
  check(SP.set_baudrate(port, 9600))
  check(SP.set_bits(port, 8))
  check(SP.set_parity(port, SP::Parity::None))
  check(SP.set_stopbits(port, 1))
  check(SP.set_flowcontrol(port, SP::FlowControl::None))

  puts "Adding port RX event to event set."
  check(SP.add_port_events(event_set, port, SP::Event::RxReady))

  ports[i] = port
end

# Now we can call SP.wait() to await any event in the set.
# It will return when an event occurs, or the timeout elapses.
puts "Waiting up to 5 seconds for RX on any port..."
check(SP.wait(event_set, 5000))

# Iterate over ports to see which have data waiting.
num_ports.times do |i|
  port = ports[i]

  # Get number of bytes waiting.
  bytes_waiting = check(SP.input_waiting(port))
  name = SP.get_port_name(port)
  name = String.new(name) if name != Pointer(UInt8).null
  puts "Port #{name}: #{bytes_waiting} bytes received."
end

# Close ports and free resources.
SP.free_event_set(event_set)
num_ports.times do |i|
  port = ports[i]
  check(SP.close(port))
  SP.free_port(port)
end
