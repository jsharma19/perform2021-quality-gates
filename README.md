# perform2021-quality-gates

## Provision infrastructure

1. Copy pre-build.sh script to the aws machine then add the env variables
```bash
export DYNATRACE_ENVIRONMENT_ID="https://test.live.dynatrace.com"
export DYNATRACE_TOKEN="tokenid"
export DYNATRACE_PAAS_TOKEN="paas token"
chmod +rx pre-build.sh
./pre-build.sh
```

2. To start over copy and run the script restart.sh
