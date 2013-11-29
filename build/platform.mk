

ifndef NOPLATFORM
VAPI+=--vapidir $(SHOTODOL_HOME)/platform/linux --pkg shotodol_platform
INCLUDES+=-I$(SHOTODOL_HOME)/platform/linux/include
LIBS+=-ldl
RDYNAMIC=-rdynamic
ifndef NOPLATFORM_EXTRA
VAPI+=--vapidir $(SHOTODOL_HOME)/platform/linux_extra/vapi --pkg shotodol_platform_extra
INCLUDES+=-I$(SHOTODOL_HOME)/platform/linux_extra/include
endif
endif

