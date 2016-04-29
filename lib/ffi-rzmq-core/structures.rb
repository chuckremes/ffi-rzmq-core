module LibZMQ

  def self.version_number
    10000 * version[:major] + 100 * version[:minor] + version[:patch]
  end

  def self.version_string
    "%d.%d.%d" % version.values_at(:major, :minor, :patch)
  end

  raise "zmq library version not supported: #{version_string}" if version_number < 030200

  # here are the typedefs for zmsg_msg_t for all known releases of libzmq
  # grep 'typedef struct zmq_msg_t'  */include/zmq.h
  # zeromq-3.2.2/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-3.2.3/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-3.2.4/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-3.2.5/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.0/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.1/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.2/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.3/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.4/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.5/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.6/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.0.7/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [32];} zmq_msg_t;
  # zeromq-4.1.0/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [48];} zmq_msg_t;
  # zeromq-4.1.1/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [64];} zmq_msg_t;
  # zeromq-4.1.2/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [64];} zmq_msg_t;
  # zeromq-4.1.3/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [64];} zmq_msg_t;
  # zeromq-4.1.4/include/zmq.h:typedef struct zmq_msg_t {unsigned char _ [64];} zmq_msg_t;
  # libzmq/include/zmq.h: typedef union zmq_msg_t {unsigned char _ [64]; void *p; } zmq_msg_t;

  def self.size_of_zmq_msg_t
    if version_number < 040100
      32
    elsif version_number < 040101
      48
    else
      64
    end
  end

  # Declare Message with correct size and alignment
  class Message < FFI::Union
    layout :'_', [:uint8, LibZMQ.size_of_zmq_msg_t],
       :p, :pointer
  end

  # Create the basic mapping for the poll_item_t structure so we can
  # access those fields via Ruby.
  #
  module PollItemLayout
    def self.included(base)
      fd_type = if FFI::Platform::IS_WINDOWS && FFI::Platform::ADDRESS_SIZE == 64
        # On Windows, zmq.h defines fd as a SOCKET, which is 64 bits on x64.
        :uint64
      else
        :int
      end

      base.class_eval do
        layout :socket,  :pointer,
          :fd,    fd_type,
          :events, :short,
          :revents, :short
      end
    end
  end


  # PollItem class includes the PollItemLayout module so that we can use the
  # basic FFI accessors to get at the structure's fields. We also want to provide
  # some higher-level Ruby accessors for convenience.
  #
  class PollItem < FFI::Struct
    include PollItemLayout

    def socket
      self[:socket]
    end

    def fd
      self[:fd]
    end

    def readable?
      (self[:revents] & ZMQ::POLLIN) > 0
    end

    def writable?
      (self[:revents] & ZMQ::POLLOUT) > 0
    end

    def inspect
      "socket [#{socket}], fd [#{fd}], events [#{self[:events]}], revents [#{self[:revents]}]"
    end
  end


  #      /*  Socket event data  */
  #      typedef struct {
  #          uint16_t event;  // id of the event as bitfield
  #          int32_t  value ; // value is either error code, fd or reconnect interval
  #      } zmq_event_t;
  module EventDataLayout
    def self.included(base)
      base.class_eval do
        layout :event, :uint16,
          :value,    :int32
      end
    end
  end # module EventDataLayout


  # Provide a few convenience methods for accessing the event structure.
  #
  class EventData < FFI::Struct
    include EventDataLayout

    def event
      self[:event]
    end

    def value
      self[:value]
    end

    def inspect
      "event [#{event}], value [#{value}]"
    end
  end # class EventData
end
