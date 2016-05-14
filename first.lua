local ffi = require("ffi")
local C = ffi.C

if ffi.os == "OSX" then
  path = "libfirst.dylib"
else
  path = "libfirst.so"
end

local first = ffi.load(path)

ffi.cdef[[
  const char* now_iso8601_utc();
  const char* random_quote();
  int add(int a, int b);
  void free(void* ptr);
]]

io.write(string.format("11 + 22 = %d\n", first.add(11, 22)))

local function quote()
  local s = first.random_quote()
  return ffi.string(s)
end

local function now_iso8601_utc()
  local s = first.now_iso8601_utc()
  return ffi.string( ffi.gc(s, C.free) )
end

io.write(string.format("\nToday's quote at %s\n\n", now_iso8601_utc()))
io.write(quote() .. "\n")
