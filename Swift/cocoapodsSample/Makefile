
archive:
	mkdir ../archive
	mkdir ../archive/final
	cp -rf ./* ../archive/final
	#zip  -rX ../steps/final.zip ./ -x "*Pods*"
	cd ../archive/final

	$(call generate_step,edge)
	$(call generate_step,extension)
	$(call generate_step,assurance)
	$(call generate_step,identity)
	$(call generate_step,event)
	$(call generate_step,pii)
	$(call generate_step,privacy)
	$(call generate_step,config)
	$(call generate_step,init)

	zip  -rX ../base.zip ./ -x "*Pods*"


define generate_step
	find . -type f -name '*.swift' | xargs sed -i "" '/.*step-$(1)-start/,/.*step-$(1)-end/d'	
	find . -type f -name 'Podfile' | xargs sed -i "" '/.*step-$(1)-start/,/.*step-$(1)-end/d'	
	#zip  -rX ../steps/$(1)_base.zip ./ -x "*Pods*"
endef

