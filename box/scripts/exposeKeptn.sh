#!/bin/bash
set -e

echo "Configure nginx-ingress and Keptn"

# Get Ingress gateway IP-Address
export INGRESS_IP=$(kubectl -n ingress-nginx get svc ingress-nginx-controller  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Check if IP-Address is not empty or pending
if [ -z "$INGRESS_IP" ] || [ "$INGRESS_IP" = "Pending" ] ; then
 	echo "INGRESS_IP is empty. Make sure that the Ingress gateway is ready"
	exit 1
fi

# Applying ingress-manifest
kubectl apply -f - <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: keptn
  namespace: keptn
spec:
  rules:
  - host: keptn.$INGRESS_IP.nip.io
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: 80
EOF