local ffi = require("ffi")

-- Extension for shared libraries
local libext = "so"
if ffi.os == "OSX" then
  libext = "dylib"
end

local libadd = ffi.load("libadd." .. libext)
ffi.cdef("int add(int, int);")

io.write(libadd.add(11, 22) .. "\n")
