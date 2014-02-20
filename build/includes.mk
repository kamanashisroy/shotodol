
#DEPEND_INCLUDES=$(foreach dir,$(DEPEND), -I$(SHOTODOL_HOME)/$(dir)/include)
DEPEND_INCLUDES=$(foreach dir,$(DEPEND), -I$(dir)/include)
INCLUDES+=$(DEPEND_INCLUDES)
