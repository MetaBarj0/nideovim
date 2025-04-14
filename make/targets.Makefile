instances/metadata:
	@touch $@

new: instances/metadata

%:
	@. scripts/forward.sh $@
