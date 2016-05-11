# To override any options, use `make -e`, e.g.
#     $ LUAJIT=/path/to/luajit make -e

ifeq ($(shell uname), Darwin)
	LIBEXT := dylib
else
	LIBEXT := so
endif

LUAJIT := luajit
CXXFLAGS := -W -Wall -g
TARGETS := foo.o libfoo.$(LIBEXT)

all: $(TARGETS)
	$(LUAJIT) foo.lua

lib%.$(LIBEXT): %.o
	$(CXX) $(CXXFLAFGS) -fpic -shared $< -o $@
	strip $@

clean:
	rm -f $(TARGETS)
