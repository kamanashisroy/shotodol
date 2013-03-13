

ifndef NOPLATFORM
VAPI+=--vapidir ../../platform/linux --pkg shotodol_platform
INCLUDES+=-I../../platform/linux/include
LIBS+=-ldl
RDYNAMIC=-rdynamic
endif

