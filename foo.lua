local ffi = require("ffi")

if ffi.os == "OSX" then
  path = "libfoo.dylib"
else 
  path = "libfoo.so"
end

io.write("Loading " .. path .. "\n")
local foo = ffi.load(path)

-- We will also need libc to call `free` on things like strings.
local C = ffi.C

ffi.cdef[[
  char* name(const struct person* p);
  int add(int a, int b);
  int age(const struct person* p);
  int days_lived(const struct person* p);
  struct person* new_person(const char* name, const int age);
  void delete_person(struct person* p);
  void foo_free(void* ptr);
]]

local function new_person(name, age)
  return ffi.gc(foo.new_person(name, age),
                foo.delete_person)
end

local function person_name(person)
  -- Can't use C.free here; why not? Dunno, either we have two different libc
  -- versions going on here, or there is some thread-lodal data or something.
  -- It's weird. TODO: Find out.
  local ptr = ffi.gc(foo.name(person), foo.foo_free)
  return ffi.string(ptr)
end

local function println(format, ...)
  io.write(string.format(format, ...) .. "\n")
end

println("1 + 2 = %d", foo.add(1, 2))

local person = new_person("Mark Twain", 74)
println("The person '%s' is %d years old",
  person_name(person),
  foo.age(person));
println("Done")
