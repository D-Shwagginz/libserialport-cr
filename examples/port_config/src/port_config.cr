require "libserialport-cr"

alias SP = SerialPort

# Set Port Names
PORT_NAMES = ["COM11"]

# Example of how to configure a serial port.

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

# Helper function to give a name for each parity mode.
def parity_name(parity : SP::Parity)
  case parity
  when SP::Parity::Invalid
    return "(Invalid)"
  when SP::Parity::None
    return "None"
  when SP::Parity::Odd
    return "Odd"
  when SP::Parity::Even
    return "Even"
  when SP::Parity::Mark
    return "Mark"
  when SP::Parity::Space
    return "Space"
  else
    return nil
  end
end

# Get the port name from the command line.
if (PORT_NAMES.size != 1)
  puts "Usage: #{PORT_NAMES[0]} <port name>\n"
  exit -1
end
port_name = PORT_NAMES[0]

# A pointer to a struct SP.port, which will refer to
# the port found.
port = Pointer(SP::Port).null

puts "Looking for port #{port_name}.\n"

# Call SP.get_port_by_name() to find the port. The port
# pointer will be updated to refer to the port found.
check(SP.get_port_by_name(port_name, pointerof(port)))

# Display some basic information about the port.
name = SP.get_port_name(port)
name = String.new(name) if name != Pointer(UInt8).null
puts "Port name: #{name}\n"
desc = SP.get_port_description(port)
desc = String.new(desc) if desc != Pointer(UInt8).null
puts "Description: #{desc}\n"

# The port must be open to access its configuration.
puts "Opening port.\n"
check(SP.open(port, SP::Mode::ReadWrite))

# There are two ways to access a port's configuration:
#
# 1. You can read and write a whole configuration (all settings at
#    once) using SP.get_config() and SP.set_config(). This is handy
#    if you want to change between some preset combinations, or save
#    and restore an existing configuration. It also ensures the
#    changes are made together, via an efficient set of calls into
#    the OS - in some cases a single system call can be used.
#
#    Use accessor functions like SP.get_config_baudrate() and
#    SP.set_config_baudrate() to get and set individual settings
#    from a configuration.
#
#    Configurations are allocated using SP.new_config() and freed
#    with SP.free_config(). You need to manage them yourself.
#
# 2. As a shortcut, you can set individual settings on a port
#    directly by calling functions like SP.set_baudrate() and
#    SP.set_parity(). This saves you the work of allocating
#    a temporary config, setting it up, applying it to a port
#    and then freeing it.
#
# In this example we'll do a bit of both: apply some initial settings
# to the port, read out that config and display it, then switch to a
# different configuration and back using SP.set_config().

# First let's set some initial settings directly on the port.
#
# You should always configure all settings before using a port.
# There are no "default" settings applied by libserialport.
# When you open a port it has the defaults from the OS or driver,
# or the settings left over by the last program to use it.
puts "Setting port to 115200 8N1, no flow control.\n"
check(SP.set_baudrate(port, 115200))
check(SP.set_bits(port, 8))
check(SP.set_parity(port, SP::Parity::None))
check(SP.set_stopbits(port, 1))
check(SP.set_flowcontrol(port, SP::FlowControl::None))

# A pointer to a struct SP.port_config, which we'll use for the config
# read back from the port. The pointer will be set by SP.new_config().
initial_config = Pointer(SP::PortConfig).null

# Allocate a configuration for us to read the port config into.
check(SP.new_config(pointerof(initial_config)))

# Read the current config from the port into that configuration.
check(SP.get_config(port, initial_config))

# Display some of the settings read back from the port.
baudrate : Int32 = 0
bits : Int32 = 0 
stopbits : Int32 = 0
parity : SP::Parity = SP::Parity.new(0)

check(SP.get_config_baudrate(initial_config, pointerof(baudrate)))
check(SP.get_config_bits(initial_config, pointerof(bits)))
check(SP.get_config_stopbits(initial_config, pointerof(stopbits)))
check(SP.get_config_parity(initial_config, pointerof(parity)))
puts "Baudrate: #{baudrate}, data bits: #{bits}, parity: #{parity_name(parity)}, stop bits: #{stopbits}\n"

# Create a different configuration to have ready for use.
puts "Creating new config for 9600 7E2, XON/XOFF flow control.\n"
other_config = Pointer(SP::PortConfig).null
check(SP.new_config(pointerof(other_config)))
check(SP.set_config_baudrate(other_config, 9600))
check(SP.set_config_bits(other_config, 7))
check(SP.set_config_parity(other_config, SP::Parity::Even))
check(SP.set_config_stopbits(other_config, 2))
check(SP.set_config_flowcontrol(other_config, SP::FlowControl::XONXOFF))

# We can apply the new config to the port in one call.
puts "Applying new configuration.\n"
check(SP.set_config(port, other_config))

# And now switch back to our original config.
puts "Setting port back to previous config.\n"
check(SP.set_config(port, initial_config))

# Now clean up by closing the port and freeing structures.
check(SP.close(port))
SP.free_port(port)
SP.free_config(initial_config)
SP.free_config(other_config)
