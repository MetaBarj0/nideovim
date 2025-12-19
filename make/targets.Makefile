instances/metadata:
	@touch $@

new: instances/metadata

delete: instances/metadata

set-default: instances/metadata

%:
	@. scripts/forward.sh $@
