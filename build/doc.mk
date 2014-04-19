
DOTTY=xdot
DOXYGEN=doxygen
include ../../build/.config.mk
include ../../build/Makevars.mk

all:doxygen

core:
	$(DOTTY) $@.dot

doxygen:
	sed -e "s:SHOTODOL_INPUT_DIRS:$(PLUGIN_DIRS):ig" Doxyfile.in > Doxyfile
	doxygen 

