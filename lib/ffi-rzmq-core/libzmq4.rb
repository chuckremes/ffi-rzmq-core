# Wraps the new API methods available in ZeroMQ 4
#
module LibZMQ

  attach_function :zmq_ctx_term,     [:pointer], :void, :blocking => true
  attach_function :zmq_ctx_shutdown, [:pointer], :void, :blocking => true

  attach_function :zmq_send_const,   [:pointer, :pointer, :size_t], :int, :blocking => true

  attach_function :zmq_z85_encode,   [:pointer, :pointer, :size_t], :string, :blocking => true
  attach_function :zmq_z85_decode,   [:pointer, :string],           :pointer, :blocking => true

end
