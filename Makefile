# To override any options, use `make -e`, e.g.
#     $ LUAJIT=/path/to/luajit make -e

ifeq ($(shell uname), Darwin)
	LIBEXT := dylib
else
	LIBEXT := so
endif

LUAJIT := luajit
CXXFLAGS := -W -Wall -g -fpic
TARGETS := libfoo.$(LIBEXT) libfirst.$(LIBEXT)

all: $(TARGETS)
	$(LUAJIT) first.lua
	$(LUAJIT) foo.lua

lib%.$(LIBEXT): %.o
	$(CXX) $(CXXFLAFGS) -shared $< -o $@
	strip $@

clean:
	rm -f $(TARGETS)
