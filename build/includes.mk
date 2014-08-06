
#DEPEND_INCLUDES=$(foreach dir,$(DEPEND), -I$(SHOTODOL_HOME)/$(dir)/include)
DEPEND_INCLUDES=$(foreach ldir,$(DEPEND), -I$(subst .,/,$(ldir))/include)
INCLUDES+=$(DEPEND_INCLUDES)
