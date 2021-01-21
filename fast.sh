

keptn install --endpoint-service-type=ClusterIP
./bootstrap/box/scripts/exposeKeptn.sh
export KEPTN_ENDPOINT=http://$(kubectl -n keptn get ingress keptn -ojsonpath='{.spec.rules[0].host}')/api