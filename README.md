# perform2021-quality-gates

## Provision infrastructure

1. Copy build.sh script to the aws machine and then run 
```bash
export DYNATRACE_ENVIRONMENT_ID="https://test.live.dynatrace.com/"
export DYNATRACE_TOKEN="tokenid"
export DYNATRACE_PAAS_TOKEN="paas token"
chmod +rx pre-build.sh
./pre-build.sh
```

2. To start over copy and run the script restart.sh
