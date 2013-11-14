
module LibZMQ
  
  def self.version
    if @version.nil?
      major = FFI::MemoryPointer.new :int
      minor = FFI::MemoryPointer.new :int
      patch = FFI::MemoryPointer.new :int
      LibZMQ.zmq_version major, minor, patch
      @version = {:major => major.read_int, :minor => minor.read_int, :patch => patch.read_int}
    end

    @version
  end

  # Sanity check; print an error and exit if we are trying to load an unsupported
  # version of libzmq.
  #
  if LibZMQ.version[:major] < 4
    hash = LibZMQ.version
    version = "#{hash[:major]}.#{hash[:minor]}.#{hash[:patch]}"
    raise LoadError, "The libzmq version #{version} is incompatible with this version of ffi-rzmq-core."
  end
end