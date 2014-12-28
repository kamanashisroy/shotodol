OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o $(OBJDIR)/propeller.o $(OBJDIR)/spindle.o
OBJECTS+=$(OBJDIR)/UnitTest.o
include $(SHOTODOL_HOME)/core/base/staticlibs.mk
include $(SHOTODOL_HOME)/libs/watchdog/staticlibs.mk
include $(SHOTODOL_HOME)/libs/config/staticlibs.mk
include $(SHOTODOL_HOME)/libs/bundle/staticlibs.mk
include $(SHOTODOL_HOME)/$(PLATFORM)/platform_extra/staticlibs.mk
include $(SHOTODOL_HOME)/libs/iostream/staticlibs.mk
include $(SHOTODOL_HOME)/libs/activeio/staticlibs.mk
include $(SHOTODOL_HOME)/libs/plugin/staticlibs.mk
include $(SHOTODOL_HOME)/libs/str_arms/staticlibs.mk
include $(SHOTODOL_HOME)/libs/make100/staticlibs.mk
include $(SHOTODOL_HOME)/libs/programming_instruction/staticlibs.mk
OBJECTS+=$(VALA_HOME)/aroop/core/libaroop_core$(AROOP_VARIANT).a
#
#LIBS+=-lm
#OBJECTS+=$(OBJDIR)/ProtoPktizer.o
#OBJECTS+=$(OBJDIR)/DBEntry.o
ifneq ($(SHOTODOL_HOME), $(PROJECT_HOME))
include $(PROJECT_HOME)/build/staticlibs.mk
endif



