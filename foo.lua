local ffi = require("ffi")

local function load_foo()
  if ffi.os == "OSX" then
    path = "libfoo.dylib"
  else
    path = "libfoo.so"
  end

  io.write("Loading " .. path .. "\n")
  local foo = ffi.load(path)
  return foo
end

-- Modified from foo.h
ffi.cdef[[
  typedef struct Person Person;

  Person* new_person(const char* name, const int age);
  char* name(const Person* p);
  int add(int a, int b);
  int age(const Person* p);
  int days_lived(const Person* p);
  void delete_person(Person* p);
  void foo_free(void* ptr);
]]

local function println(format, ...)
  io.write(string.format(format, ...) .. "\n")
end

local foo = load_foo()

-- The PersonWrapper idea was taken from
-- http://lua-users.org/lists/lua-l/2011-07/msg00496.html

local PersonWrapper = {}
PersonWrapper.__index = PersonWrapper

function PersonWrapper.name(self)
  local name = foo.name(self.super)
  ffi.gc(name, foo.foo_free)
  return ffi.string(name)
end

function PersonWrapper.age(self)
  return foo.age(self.super)
end

local function Person(...)
  local self = {super = foo.new_person(...)}
  ffi.gc(self.super, foo.delete_person)
  return setmetatable(self, PersonWrapper)
end

local function main()
  -- A plain old C function
  println("1 + 2 = %d", foo.add(1, 2))

  -- Use the PersonWrapper stuff to work with C++ objects
  local person = Person("Mark Twain", 74)
  println("'%s' is %d years old", person:name(), person:age());
  println("Done")
end

main()
