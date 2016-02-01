OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o
OBJECTS+=$(OBJDIR)/UnitTest.o
include $(SHOTODOL_HOME)/libs/fiber/staticlibs.mk
include $(SHOTODOL_HOME)/core/base/staticlibs.mk
include $(SHOTODOL_HOME)/libs/watchdog/staticlibs.mk
include $(SHOTODOL_HOME)/libs/config/staticlibs.mk
include $(SHOTODOL_HOME)/libs/bundle/staticlibs.mk
include $(SHOTODOL_HOME)/$(PLATFORM)/platform_extra/staticlibs.mk
include $(SHOTODOL_HOME)/libs/iostream/staticlibs.mk
include $(SHOTODOL_HOME)/libs/activeio/staticlibs.mk
include $(SHOTODOL_HOME)/libs/plugin/staticlibs.mk
include $(SHOTODOL_HOME)/libs/linterpreter/staticlibs.mk
include $(SHOTODOL_HOME)/libs/make100/staticlibs.mk
include $(SHOTODOL_HOME)/libs/programming_instruction/staticlibs.mk
OBJECTS+=$(shell $(AROOPC) --show-c-libdir)/libaroop_core$(AROOP_VARIANT).a
#
#LIBS+=-lm
#OBJECTS+=$(OBJDIR)/ProtoPktizer.o
#OBJECTS+=$(OBJDIR)/DBEntry.o
ifneq ($(SHOTODOL_HOME), $(PROJECT_HOME))
include $(PROJECT_HOME)/build/staticlibs.mk
endif



