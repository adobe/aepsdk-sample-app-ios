
archive:
	mkdir ../steps
	zip  -rX ../steps/final.zip ./ -x "*Pods*"

	$(call generate_step,assurance)
	$(call generate_step,identity)
	$(call generate_step,event)
	$(call generate_step,pii)
	$(call generate_step,privacy)
	$(call generate_step,config)
	$(call generate_step,init)

	cd .. && zip  -rX ./apps.zip ./steps/


define generate_step
	find . -type f -name '*.swift' | xargs sed -i "" '/.*step-$(1)-start/,/.*step-$(1)-end/d'	
	find . -type f -name 'Podfile' | xargs sed -i "" '/.*step-$(1)-start/,/.*step-$(1)-end/d'	
	zip  -rX ../steps/$(1)_base.zip ./ -x "*Pods*"
endef

