require "libserialport-cr"

alias SP = SerialPort

# Example of how to handle errors from libserialport.

module HandleErrors
  # Pointers used in the program to resources that may need to be freed.
  @@port_list = [] of Pointer(SP::Port)
  @@config = Pointer(SP::PortConfig).null
  @@port = Pointer(SP::Port).null

  # Example of a function to clean up and exit the program with a given return code.
  def self.end_program(return_code : Int)
    # Free any structures we allocated.
    if (@@port_list != nil)
      SP.free_port_list(@@port_list)
    end
    if (@@config != nil)
      SP.free_config(@@config)
    end
    if (@@port != nil)
      SP.free_port(@@port)
    end

    # Exit with the given return code.
    exit return_code
  end

  # Example of a helper function for error handling.
  def self.check(result : SP::Return) : SP::Return
    error_code : Int32
    error_message : Pointer(UInt8)

    case result
    # Handle each of the four negative error codes that can be returned.
    #
    # In this example, we will end the program on any error, using
    # a different return code for each possible class of error.

    when SP::Return::ErrArg
      # When SP_ERR_ARG is returned, there was a problem with one
      # or more of the arguments passed to the function, e.g. a null
      # pointer or an invalid value. This generally implies a bug in
      # the calling code.
      puts "Error: Invalid argument.\n"
      end_program(1)
    when SP::Return::ErrFail
      # When SP_ERR_FAIL is returned, there was an error from the OS,
      # which we can obtain the error code and message for. These
      # calls must be made in the same thread as the call that
      # returned SP_ERR_FAIL, and before any other system functions
      # are called in that thread, or they may not return the
      # correct results.
      error_code = SP.last_error_code
      error_message = SP.last_error_message
      puts "Error: Failed: OS error code: #{error_code}, message: '#{String.new(error_message)}'\n"
      # The error message should be freed after use.
      SP.free_error_message(error_message)
      end_program(2)
    when SP::Return::ErrSupp
      # When SP_ERR_SUPP is returned, the function was asked to do
      # something that isn't supported by the current OS or device,
      # or that libserialport doesn't know how to do in the current
      # version.
      puts "Error: Not supported.\n"
      end_program(3)
    when SP::Return::ErrMem
      # When SP_ERR_MEM is returned, libserialport wasn't able to
      # allocate some memory it needed. Since the library doesn't
      # normally use any large data structures, this probably means
      # the system is critically low on memory and recovery will
      # require very careful handling. The library itself will
      # always try to handle any allocation failure safely.
      #
      # In this example, we'll just try to exit gracefully without
      # calling printf, which might need to allocate further memory.
      end_program(4)
    when SP::Return::Ok
    else
      # A return value of SP_OK, defined as zero, means that the
      # operation succeeded.
      puts "Operation succeeded.\n"
      # Some fuctions can also return a value greater than zero to
      # indicate a numeric result, such as the number of bytes read by
      # SP.blocking_read(). So when writing an error handling wrapper
      # function like this one, it's helpful to return the result so
      # that it can be used.
    end
    return result
  end

  # Call some functions that should not result in errors.

  puts "Getting list of ports.\n"
  ports_ptr = @@port_list.to_unsafe
  check(SP.list_ports(pointerof(ports_ptr)))

  puts "Creating a new port configuration.\n"
  check(SP.new_config(pointerof(@@config)))

  # Now make a function call that will result in an error.

  puts "Trying to find a port that doesn't exist.\n"
  check(SP.get_port_by_name("NON-EXISTENT-PORT", pointerof(@@port)))

  # We could now clean up and exit normally if an error hadn't occured.
  end_program(0)
end
