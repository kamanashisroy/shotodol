
include ../../.config.mk
VALAC=$(VALA_HOME)/aroop/compiler/aroopc
VAPI=--vapidir $(VALA_HOME)/vapi
VAPI+=--vapidir $(VALA_HOME)/aroop/vapi --pkg aroop_pthread-0.1
#VAPI+=--vapidir $(VALA_HOME)/aroop/vapi --pkg aroop_component-1.0
include ../../build/platform.mk
include vapi.mk
VSOURCES=$(wildcard vsrc/*.vala)

TARGET_INCLUDE=include/$(LIBRARY_NAME).h
TARGET_VAPI=vapi/$(LIBRARY_NAME).vapi
TARGETS=$(TARGET_INCLUDE) $(TARGET_VAPI)

all:genvapi

genvapi:$(VSOURCES)
	mkdir -p vapi include
	$(VALAC) --profile=aroop -D POSIX -C  $(VAPI) --library $(LIBRARY_NAME) --vapi=$(TARGET_VAPI) --use-header --header=$(TARGET_INCLUDE) $(VSOURCES)

clean:
	$(RM) -f $(wildcard vsrc/*.c) $(TARGETS)

