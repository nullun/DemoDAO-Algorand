#!/usr/bin/env bash

set -e -u -x

SB="$HOME/sandbox/sandbox"
GOAL="${SB} goal"

ADDR=$(${GOAL} account list | head -n 1 | awk '{print $3}' | tr -d '\r')
VOTER=$(${GOAL} account list | sed -n 3p | awk '{print $3}' | tr -d '\r')

${SB} copyTo approval.teal
${SB} copyTo clear.teal

# Deploy
APP_ID=$(${GOAL} app method \
	--method "deploy(string)bool" \
	--create \
	--from ${ADDR} \
	--approval-prog approval.teal \
	--clear-prog clear.teal \
	--global-byteslices 0 --global-ints 3 \
	--local-byteslices 0 --local-ints 0 \
	--arg '"Test DAO"' \
	| grep 'Created app with app index' \
	| awk '{print $6}' \
	| tr -d '\r')
APP_ADDR=$(${GOAL} app info \
	--app-id ${APP_ID} \
	| grep 'Application account' \
	| awk '{print $3}' \
	| tr -d '\r')

# Create Asset
ASSET_ID=$(${GOAL} asset create \
	--creator ${ADDR} \
	--name "Test Asset" \
	--unitname "TA" \
	--total 100 \
	--decimals 0 \
	| grep 'Created asset with asset index' \
	| awk '{print $6}' \
	| tr -d '\r')

# Voter OptIn to Asset
${GOAL} asset send \
	--from ${VOTER} \
	--to ${VOTER} \
	--assetid ${ASSET_ID} \
	--amount 0

# Send Voter Assets
${GOAL} asset send \
	--from ${ADDR} \
	--to ${VOTER} \
	--assetid ${ASSET_ID} \
	--amount 20

# Fund DAO
${GOAL} clerk send \
	--from ${ADDR} \
	--to ${APP_ADDR} \
	--amount 10000000

# Initialise
${GOAL} app method \
	--method "initialise(asset)bool" \
	--from ${ADDR} \
	--app-id ${APP_ID} \
	--arg ${ASSET_ID} \
	--fee 2000

# Deploy Proposed Functionality 1
#${SB} copyTo functionality1.teal
FUNC_TEAL="func_optin_to_asas.teal"
${SB} copyTo ${FUNC_TEAL}
${SB} copyTo int0.teal
${GOAL} app method \
	--method "deploy()void" \
	--create \
	--from ${ADDR} \
	--approval-prog ${FUNC_TEAL} \
	--clear-prog int0.teal \
	--global-byteslices 8 --global-ints 8 \
	--local-byteslices 4 --local-ints 4 \
	-o appl.txn

# Propose Functionality 1
PROP_APP_ID=$(${GOAL} app method \
	--method "propose(appl)uint64" \
	--from ${ADDR} \
	--app-id ${APP_ID} \
	--on-completion "NoOp" \
	--arg appl.txn \
	| grep 'method propose(appl)uint64 succeeded with output' \
	| awk '{print $6}' \
	| tr -d '\r')

# Vote
${GOAL} app method \
	--method "vote(application,asset,uint64)bool" \
	--from ${VOTER} \
	--app-id ${APP_ID} \
	--on-completion "NoOp" \
	--arg ${PROP_APP_ID} \
	--arg ${ASSET_ID} \
	--arg 20

# Activate
FUNC_APP_ID=$(${GOAL} app method \
	--method "activate(application)uint64" \
	--from ${ADDR} \
	--app-id ${APP_ID} \
	--on-completion "NoOp" \
	--arg ${PROP_APP_ID} \
	--fee 2000 \
	| grep 'method activate(application)uint64 succeeded with output' \
	| awk '{print $6}' \
	| tr -d '\r')

# Delete Proposal
${GOAL} app method \
	--method "deactivate()bool" \
	--from ${ADDR} \
	--app-id ${PROP_APP_ID} \
	--on-completion "DeleteApplication"

# Create fake USDC
USDC_ID=$(${GOAL} asset create \
	--creator ${ADDR} \
	--name "Fake USDC" \
	--unitname "FUSDC" \
	--total 18446744073709551615 \
	--decimals 6 \
	| grep 'Created asset with asset index' \
	| awk '{print $6}' \
	| tr -d '\r')

# Create fake USDT
USDT_ID=$(${GOAL} asset create \
	--creator ${ADDR} \
	--name "Fake USDT" \
	--unitname "FUSDT" \
	--total 18446744073709551615 \
	--decimals 6 \
	| grep 'Created asset with asset index' \
	| awk '{print $6}' \
	| tr -d '\r')

# Invoke
${GOAL} app method \
	--method "invoke(application)bool" \
	--from ${ADDR} \
	--app-id ${APP_ID} \
	--on-completion "NoOp" \
	--arg ${FUNC_APP_ID} \
	--foreign-asset ${USDC_ID} \
	--foreign-asset ${USDT_ID}

exit

# Destroy
${GOAL} app method \
	--method "destroy()bool" \
	--from ${ADDR} \
	--app-id ${APP_ID} \
	--on-completion "DeleteApplication"

