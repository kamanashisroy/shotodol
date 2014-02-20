OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o $(OBJDIR)/propeller.o $(OBJDIR)/spindle.o
OBJECTS+=$(OBJDIR)/MainTurbine.o
OBJECTS+=$(OBJDIR)/InputStream.o
OBJECTS+=$(OBJDIR)/FileInputStream.o
OBJECTS+=$(OBJDIR)/BrainEngine.o
OBJECTS+=$(OBJDIR)/Watchdog.o
OBJECTS+=$(OBJDIR)/UnitTest.o
OBJECTS+=$(OBJDIR)/ConfigEngine.o
OBJECTS+=$(OBJDIR)/M100CommandOption.o
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
