@[Link("libserialport")]
lib SerialPort
  VERSION = 1.0

  # The libserialport package 'major' version number.
  PACKAGE_VERSION_MAJOR = 0

  # The libserialport package 'minor' version number.
  PACKAGE_VERSION_MINOR = 1

  # The libserialport package 'micro' version number.
  PACKAGE_VERSION_MICRO = 1

  # The libserialport package version ("major.minor.micro") as string.
  PACKAGE_VERSION_STRING = "0.1.1"

  # The libserialport libtool 'current' version number.
  LIB_VERSION_CURRENT = 1

  # The libserialport libtool 'revision' version number.
  LIB_VERSION_REVISION = 0

  # The libserialport libtool 'age' version number.
  LIB_VERSION_AGE = 1

  # The libserialport libtool version ("current:revision:age") as string.
  LIB_VERSION_STRING = "1:0:1"

  # @example list_ports.cr Getting a list of ports present on the system.
  # @example port_info.cr Getting information on a particular serial port.
  # @example port_config.cr Accessing configuration settings of a port.
  # @example send_receive.cr Sending and receiving data.
  # @example await_events.cr Awaiting events on multiple ports.
  # @example handle_errors.cr Handling errors returned from the library.

  # Return Values
  enum Return
    # Operation completed successfully.
    Ok = 0
    # Invalid arguments were passed to the function.
    ErrArg = -1
    # A system error occurred while executing the operation.
    ErrFail = -2
    # A memory allocation failed while executing the operation.
    ErrMem = -3
    # The requested operation is not supported by this system or device.
    ErrSupp = -4
  end

  # Port access modes.
  enum Mode
    # Open port for read access.
    Read = 1
    # Open port for write access.
    Write = 2
    # Open port for read and write access.
    ReadWrite = 3
  end

  # Port events.
  enum Event
    # Data received and ready to read.
    RxReady = 1
    # Ready to transmit new data.
    TxReady = 2
    # Error occurred.
    Error = 4
  end

  # Buffer selection.
  enum Buffer
    # Input buffer.
    Input = 1
    # Output buffer.
    Output = 2
    # Both buffers.
    Both = 3
  end

  # Parity settings.
  enum Parity
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # No parity.
    None = 0
    # Odd parity.
    Odd = 1
    # Even parity.
    Even = 2
    # Mark parity.
    Mark = 3
    # Space parity.
    Space = 4
  end

  # RTS pin behaviour.
  enum RTS
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # RTS off.
    Off = 0
    # RTS on.
    On = 1
    # RTS used for flow control.
    FlowControl = 2
  end

  # CTS pin behaviour.
  enum CTS
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # CTS ignored.
    Ignore = 0
    # CTS used for flow control.
    FlowControl = 1
  end

  # DTR pin behaviour.
  enum DTR
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # DTR off.
    Off = 0
    # DTR on.
    On = 1
    # DTR used for flow control.
    FlowControl = 2
  end

  # DSR pin behaviour.
  enum DSR
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # DSR ignored.
    Ignore = 0
    # DSR used for flow control.
    FlowControl = 1
  end

  # XON/XOFF flow control behaviour.
  enum XONXOFF
    # Special value to indicate setting should be left alone.
    Invalid = -1
    # XON/XOFF disabled.
    Disabled = 0
    # XON/XOFF enabled for input only.
    In = 1
    # XON/XOFF enabled for output only.
    Out = 2
    # XON/XOFF enabled for input and output.
    InOut = 3
  end

  # Standard flow control combinations.
  enum FlowControl
    # No flow control.
    None = 0
    # Software flow control using XON/XOFF characters.
    XONXOFF = 1
    # Hardware flow control using RTS/CTS signals.
    RTSCTS = 2
    # Hardware flow control using DTR/DSR signals.
    DTRDSR = 3
  end

  # Input signals.
  enum Signal
    # Clear to send.
    CTS = 1
    # Data set ready.
    DSR = 2
    # Data carrier detect.
    DCD = 4
    # Ring indicator.
    RI = 8
  end

  # Transport types.
  enum Transport
    # Native platform serial port.
    Native = 0
    # USB serial port adapter.
    Usb = 1
    # Bluetooth serial port adapter.
    Bluetooth = 2
  end

  # An opaque type representing a serial port.
  type Port = Void

  # An opaque type representing the configuration for a serial port.
  type PortConfig = Void

  # A set of handles to wait on for events.
  struct EventSet
    # Array of OS-specific handles.
    handles : Void*
    # Array of bitmasks indicating which events apply for each handle.
    masks : Event*
    # Number of handles.
    count : LibC::UInt
  end

  # Obtain a pointer to a new sp_port structure representing the named port.
  fun get_port_by_name = sp_get_port_by_name(portname : LibC::Char*, port_ptr : Port**) : Return

  # Free a port structure obtained from sp_get_port_by_name() or sp_copy_port().
  fun free_port = sp_free_port(port : Port*) : Void

  # List the serial ports available on the system.
  fun list_ports = sp_list_ports(list_ptr : Port***) : Return

  # Make a new copy of an sp_port structure.
  fun copy_port = sp_copy_port(port : Port*, copy_ptr : Port**) : Return

  # Free a port list obtained from sp_list_ports()
  fun free_port_list = sp_free_port_list(ports : Port**) : Void

  # Open the specified serial port.
  fun open = sp_open(port : Port*, flags : Mode) : Return

  # Close the specified serial port.
  fun close = sp_close(port : Port*) : Return

  # Get the name of a port.
  fun get_port_name = sp_get_port_name(port : Port*) : LibC::Char*

  # Get a description for a port, to present to end user.
  fun get_port_description = sp_get_port_description(port : Port*) : LibC::Char*

  # Get the transport type used by a port.
  fun get_port_transport = sp_get_port_transport(port : Port*) : Transport

  # Get the USB bus number and address on bus of a USB serial adapter port.
  fun get_port_usb_bus_address = sp_get_port_usb_bus_address(port : Port*, usb_bus : LibC::Int*, usb_address : LibC::Int*) : Return

  # Get the USB Vendor ID and Product ID of a USB serial adapter port.
  fun get_port_usb_vid_pid = sp_get_port_usb_vid_pid(port : Port*, usb_vid : LibC::Int*, usb_pid : LibC::Int*) : Return

  # Get the USB manufacturer string of a USB serial adapter port.
  fun get_port_usb_manufacturer = sp_get_port_usb_manufacturer(port : Port*) : LibC::Char*

  # Get the USB product string of a USB serial adapter port.
  fun get_port_usb_product = sp_get_port_usb_product(port : Port*) : LibC::Char*

  # Get the USB serial number string of a USB serial adapter port.
  fun get_port_usb_serial = sp_get_port_usb_serial(port : Port*) : LibC::Char*

  # Get the MAC address of a Bluetooth serial adapter port.
  fun get_port_bluetooth_address = sp_get_port_bluetooth_address(port : Port*) : LibC::Char*

  # Get the operating system handle for a port.
  fun get_port_handle = sp_get_port_handle(port : Port*, result_ptr : Void*) : Return

  # Allocate a port configuration structure.
  fun new_config = sp_new_config(config_ptr : PortConfig**) : Return

  # Free a port configuration structure.
  fun free_config = sp_free_config(config : PortConfig*) : Void

  # Get the current configuration of the specified serial port.
  fun get_config = sp_get_config(port : Port*, config : PortConfig*) : Return

  # Set the configuration for the specified serial port.
  fun set_config = sp_set_config(port : Port*, config : PortConfig*) : Return

  # Set the baud rate for the specified serial port.
  fun set_baudrate = sp_set_baudrate(port : Port*, baudrate : LibC::Int) : Return

  # Get the baud rate from a port configuration.
  fun get_config_baudrate = sp_get_config_baudrate(config : PortConfig*, baudrate_ptr : LibC::Int*) : Return

  # Set the baud rate in a port configuration.
  fun set_config_baudrate = sp_set_config_baudrate(config : PortConfig*, baudrate : LibC::Int) : Return

  # Set the data bits for the specified serial port.
  fun set_bits = sp_set_bits(port : Port*, bits : LibC::Int) : Return

  # Get the data bits from a port configuration.
  fun get_config_bits = sp_get_config_bits(cconfig : PortConfig*, bits_ptr : LibC::Int*) : Return

  # Set the data bits in a port configuration.
  fun set_config_bits = sp_set_config_bits(config : PortConfig*, bits : LibC::Int) : Return

  # Set the parity setting for the specified serial port.
  fun set_parity = sp_set_parity(port : Port*, parity : Parity) : Return

  # Get the parity setting from a port configuration.
  fun get_config_parity = sp_get_config_parity(config : PortConfig*, parity_ptr : Parity*) : Return

  # Set the parity setting in a port configuration.
  fun set_config_parity = sp_set_config_parity(config : PortConfig*, parity : Parity) : Return

  # Set the stop bits for the specified serial port.
  fun set_stopbits = sp_set_stopbits(port : Port*, stopbits : LibC::Int) : Return

  # Get the stop bits from a port configuration.
  fun get_config_stopbits = sp_get_config_stopbits(config : PortConfig*, stopbits_ptr : LibC::Int*) : Return

  # Set the stop bits in a port configuration.
  fun set_config_stopbits = sp_set_config_stopbits(config : PortConfig*, stopbits : LibC::Int) : Return

  # Set the RTS pin behaviour for the specified serial port.
  fun set_rts = sp_set_rts(port : Port*, rts : RTS) : Return

  # Get the RTS pin behaviour from a port configuration.
  fun get_config_rts = sp_get_config_rts(config : PortConfig*, rts_ptr : RTS*) : Return

  # Set the RTS pin behaviour in a port configuration.
  fun set_config_rts = sp_set_config_rts(config : PortConfig*, rts : RTS) : Return

  # Set the CTS pin behaviour for the specified serial port.
  fun set_cts = sp_set_cts(port : Port*, cts : CTS) : Return

  # Get the CTS pin behaviour from a port configuration.
  fun get_config_cts = sp_get_config_cts(config : PortConfig*, cts_ptr : CTS*) : Return

  # Set the CTS pin behaviour in a port configuration.
  fun set_config_cts = sp_set_config_cts(config : PortConfig*, cts : CTS) : Return

  # Set the DTR pin behaviour for the specified serial port.
  fun set_dtr = sp_set_dtr(port : Port*, dtr : DTR) : Return

  # Get the DTR pin behaviour from a port configuration.
  fun get_config_dtr = sp_get_config_dtr(config : PortConfig*, dtr_ptr : DTR*) : Return

  # Set the DTR pin behaviour in a port configuration.
  fun set_config_dtr = sp_set_config_dtr(config : PortConfig*, dtr : DTR) : Return

  # Set the DSR pin behaviour for the specified serial port.
  fun set_dsr = sp_set_dsr(port : Port*, dsr : DSR) : Return

  # Get the DSR pin behaviour from a port configuration.
  fun get_config_dsr = sp_get_config_dsr(config : PortConfig*, dsr_ptr : DSR*) : Return

  # Set the DSR pin behaviour in a port configuration.
  fun set_config_dsr = sp_set_config_dsr(config : PortConfig*, dsr : DSR) : Return

  # Set the XON/XOFF configuration for the specified serial port.
  fun set_xon_xoff = sp_set_xon_xoff(port : Port*, xon_xoff : XONXOFF) : Return

  # Get the XON/XOFF configuration from a port configuration.
  fun get_config_xon_xoff = sp_get_config_xon_xoff(config : PortConfig*, xon_xoff_ptr : XONXOFF*) : Return

  # Set the XON/XOFF configuration in a port configuration.
  fun set_config_xon_xoff = sp_set_config_xon_xoff(config : PortConfig*, xon_xoff : XONXOFF) : Return

  # Set the flow control type in a port configuration.
  fun set_config_flowcontrol = sp_set_config_flowcontrol(config : PortConfig*, flowcontrol : FlowControl) : Return

  # Set the flow control type for the specified serial port.
  fun set_flowcontrol = sp_set_flowcontrol(port : Port*, flowcontrol : FlowControl) : Return

  # Read bytes from the specified serial port, blocking until complete.
  fun blocking_read = sp_blocking_read(port : Port*, buf : Void*, count : LibC::Long, timeout_ms : LibC::UInt) : Return

  # Read bytes from the specified serial port, returning as soon as any data is
  fun blocking_read_next = sp_blocking_read_next(port : Port*, buf : Void*, count : LibC::Long, timeout_ms : LibC::UInt) : Return

  # Read bytes from the specified serial port, without blocking.
  fun nonblocking_read = sp_nonblocking_read(port : Port*, buf : Void*, count : LibC::Long) : Return

  # Write bytes to the specified serial port, blocking until complete.
  fun blocking_write = sp_blocking_write(port : Port*, buf : Void*, count : LibC::Long, timeout_ms : LibC::UInt) : Return

  # Write bytes to the specified serial port, without blocking.
  fun nonblocking_write = sp_nonblocking_write(port : Port*, buf : Void*, count : LibC::Long) : Return

  # Gets the number of bytes waiting in the input buffer.
  fun input_waiting = sp_input_waiting(port : Port*) : Return

  # Gets the number of bytes waiting in the output buffer.
  fun output_waiting = sp_output_waiting(port : Port*) : Return

  # Flush serial port buffers. Data in the selected buffer(s) is discarded.
  fun flush = sp_flush(port : Port*, buffers : Buffer) : Return

  # Wait for buffered data to be transmitted.
  fun drain = sp_drain(port : Port*) : Return

  # Allocate storage for a set of events.
  fun new_event_set = sp_new_event_set(result_ptr : EventSet**) : Return

  # Add events to a struct sp_event_set for a given port.
  fun add_port_events = sp_add_port_events(event_set : EventSet*, port : Port*, mask : Event) : Return

  # Wait for any of a set of events to occur.
  fun wait = sp_wait(event_set : EventSet*, timeout_ms : LibC::UInt) : Return

  # Free a structure allocated by sp_new_event_set().
  fun free_event_set = sp_free_event_set(event_set : EventSet*) : Void

  # Gets the status of the control signals for the specified port.
  fun get_signals = sp_get_signals(port : Port*, signal_mask : Signal*) : Return

  # Put the port transmit line into the break state.
  fun start_break = sp_start_break(port : Port*) : Return

  # Take the port transmit line out of the break state.
  fun end_break = sp_end_break(port : Port*) : Return

  # Get the error code for a failed operation.
  fun last_error_code = sp_last_error_code : LibC::Int

  # Get the error message for a failed operation.
  fun last_error_message = sp_last_error_message : LibC::Char*

  # Free an error message returned by sp_last_error_message().
  fun free_error_message = sp_free_error_message(message : LibC::Char*) : Void

  # NOTE: I didn't feel like figuring out the handlers, and it didn't seem like a high priority
  #   # Set the handler function for library debugging messages.
  #   fun set_debug_handler = sp_set_debug_handler(void (*handler)(const char *format, ...)) : Void
  #   # Default handler function for library debugging messages.
  #   fun default_debug_handler = sp_default_debug_handler(const char *format, ...) : Void

  # Get the major libserialport package version number.
  fun get_major_package_version = sp_get_major_package_version : LibC::Int

  # Get the minor libserialport package version number.
  fun get_minor_package_version = sp_get_minor_package_version : LibC::Int

  # Get the micro libserialport package version number.
  fun get_micro_package_version = sp_get_micro_package_version : LibC::Int

  # Get the libserialport package version number as a string.
  fun get_package_version_string = sp_get_package_version_string : LibC::Char*

  # Get the "current" part of the libserialport library version number.
  fun get_current_lib_version = sp_get_current_lib_version : LibC::Int

  # Get the "revision" part of the libserialport library version number.
  fun get_revision_lib_version = sp_get_revision_lib_version : LibC::Int

  # Get the "age" part of the libserialport library version number.
  fun get_age_lib_version = sp_get_age_lib_version : LibC::Int

  # Get the libserialport library version number as a string.
  fun get_lib_version_string = sp_get_lib_version_string : LibC::Char*
end
