# perform2021-quality-gates

## Provision infrastructure

1. Copy build.sh script to the aws machine and then run 
```bash
export DYNATRACE_ENVIRONMENT_ID="https://test.live.dynatrace.com/"
export DYNATRACE_TOKEN="tokenid"
export DYNATRACE_PAAS_TOKEN="paas token"
chmod +rx build.sh
./build.sh
```

2. To start over
```bash
rm -rf bootstrap
/usr/local/bin/k3s-uninstall.sh
```