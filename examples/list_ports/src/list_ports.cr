require "libserialport-cr"

alias SP = SerialPort

# Example of how to get a list of serial ports on the system.

# A pointer to a null-terminated array of pointers to
# struct SP.port, which will contain the ports found.
port_list = [] of Pointer(SP::Port)

puts "Getting port list.\n"

# Call SP.list_ports() to get the ports. The port_list
# pointer will be updated to refer to the array created.
ports_ptr = port_list.to_unsafe
result = SP.list_ports(pointerof(ports_ptr))
port_list = ports_ptr

if (result != SP::Return::Ok)
  print "SP.list_ports() failed!\n"
  exit -1
end

# Iterate through the ports. When port_list[i] is NULL
# this indicates the end of the list.
ports_found = 0
i = 0
until port_list[i] == Pointer(SP::Port).null
  port = port_list[i]

  # Get the name of the port.
  port_name = SP.get_port_name(port)

  port_name = String.new(port_name) if port_name != Pointer(UInt8).null
  puts "Found port: #{port_name}\n"
  ports_found += 1
  i += 1
end

puts "Found #{ports_found} ports.\n"

puts "Freeing port list.\n"

# Free the array created by SP.list_ports().
SP.free_port_list(port_list)

# Note that this will also free all the SP.port structures
# it points to. If you want to keep one of them (e.g. to
# use that port in the rest of your program), take a copy
# of it first using SP.copy_port().
