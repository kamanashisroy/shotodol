OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o $(OBJDIR)/propeller.o $(OBJDIR)/spindle.o
OBJECTS+=$(OBJDIR)/UnitTest.o
include $(SHOTODOL_HOME)/core/base/staticlibs.mk
include $(SHOTODOL_HOME)/libs/watchdog/staticlibs.mk
include $(SHOTODOL_HOME)/libs/config/staticlibs.mk
include $(SHOTODOL_HOME)/$(PLATFORM)/platform_extra/staticlibs.mk
include $(SHOTODOL_HOME)/$(PLATFORM)/platform_net/staticlibs.mk
include $(SHOTODOL_HOME)/libs/iostream/staticlibs.mk
include $(SHOTODOL_HOME)/libs/plugin/staticlibs.mk
include $(SHOTODOL_HOME)/libs/str_arms/staticlibs.mk
include $(SHOTODOL_HOME)/libs/make100/staticlibs.mk
include $(SHOTODOL_HOME)/libs/bundle/staticlibs.mk
include $(SHOTODOL_HOME)/libs/programming_instruction/staticlibs.mk
ifneq ("$(LUA_LIB)", "n")
include $(SHOTODOL_HOME)/linux/lua/staticlibs.mk
endif
OBJECTS+=$(VALA_HOME)/aroop/core/libaroop_core.o
#
#OBJECTS+=$(OBJDIR)/imageio.o
#OBJECTS+=$(OBJDIR)/fast-edge.o
#OBJECTS+=$(OBJDIR)/shotodol_fastedge.o
#OBJECTS+=$(OBJDIR)/dryman_kmeans.o
#LIBS+=-lm
#OBJECTS+=$(OBJDIR)/ProtoPktizer.o
#OBJECTS+=$(OBJDIR)/DBEntry.o
ifneq ($(SHOTODOL_HOME), $(PROJECT_HOME))
include $(PROJECT_HOME)/build/staticlibs.mk
endif



