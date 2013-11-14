ffi-rzmq-core
=============

The intention of this gem is to provide a very basic FFI wrapper around the Zeromq libzmq C API.
This gem isn't intended to be used directly by any Ruby programmer looking to write Zeromq code.
They should use a higher-level gem like ffi-rzmq which pulls in this gem for its FFI definitions.

There have been complaints that the ffi-rzmq gem doesn't provide the correct or best Ruby idioms, so I am
hoping this encourages other library writers to create their own. Rather than duplicate the FFI
wrapping code, they can just pull in this gem and build a more idiomatic library around the
basic definitions.

See [ffi-rzmq]