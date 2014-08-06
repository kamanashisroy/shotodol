

DEPEND_VAPI=$(foreach ldir,$(DEPEND), --vapidir $(subst .,/,$(ldir))/vapi --pkg shotodol_$(subst .,_,$(notdir $(ldir))))
VAPI+=$(DEPEND_VAPI)
