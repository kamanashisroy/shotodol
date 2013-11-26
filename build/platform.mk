

ifndef NOPLATFORM
VAPI+=--vapidir $(SHOTODOL_HOME)/platform/linux --pkg shotodol_platform
INCLUDES+=-I$(SHOTODOL_HOME)/platform/linux/include
LIBS+=-ldl
RDYNAMIC=-rdynamic
endif

