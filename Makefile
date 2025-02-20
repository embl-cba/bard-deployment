hello:
	echo "Hello, World"

update-py-os-config:
	kubectl create -n abcdesktop-external-ns configmap abcdesktop-config --from-file=od.config -o yaml --dry-run=client | kubectl replace -n abcdesktop-external-ns -f - && kubectl -n abcdesktop-external-ns delete pod -l name=pyos-od