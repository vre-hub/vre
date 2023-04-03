kubectl create secret generic jhub-cvre-iam-secrets --from-literal=client_id=""  --from-literal=client_secret="" --dry-run=client -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=shared-services --format yaml --namespace=jhub > ss_jhub-cvre-iam-secrets.yaml

kubectl create secret tls cern-sectigo-tls-certificate --key="tls.key" --cert="tls.crt" --dry-run=client -o yaml | \
kubeseal --controller-name=sealed-secrets-cvre --controller-namespace=shared-services --format yaml --namespace=jhub > ss_cern-sectigo-tls-certificate.yaml
