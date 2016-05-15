local ffi = require("ffi")
local C = ffi.C

-- Extension for shared libraries
local libext = "so"
if ffi.os == "OSX" then
  libext = "dylib"
end

local libperson = ffi.load("libperson." .. libext)

ffi.cdef[[
  /* From our library */
  typedef struct Person Person;
  Person* new_person(const char* name, const int age);
  char* name(const Person* p);
  int age(const Person* p);
  void delete_person(Person* p);

  /* From the C library */
  void free(void*);
]]

local PersonWrapper = {}
PersonWrapper.__index = PersonWrapper

local function Person(...)
  local self = {super = libperson.new_person(...)}
  ffi.gc(self.super, libperson.delete_person)
  return setmetatable(self, PersonWrapper)
end

function PersonWrapper.name(self)
  local name = libperson.name(self.super)
  ffi.gc(name, C.free)
  return ffi.string(name)
end

function PersonWrapper.age(self)
  return libperson.age(self.super)
end

local person = Person("Mark Twain", 74)
io.write(string.format("'%s' is %d years old\n", person:name(), person:age()))
