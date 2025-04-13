instances/metadata:
	@touch $@

new: instances/metadata

%:
	@. scripts/%.sh $@
