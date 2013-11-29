

DEPEND_VAPI=$(foreach dir,$(DEPEND), --vapidir $(SHOTODOL_HOME)/$(dir)/vapi --pkg shotodol_$(subst .,,$(suffix $(subst /,.,$(dir)))))
VAPI+=$(DEPEND_VAPI)
