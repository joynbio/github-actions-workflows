#!/usr/bin/env bash

if [[ $# -ne 3 ]]; then
  echo "FAILURE: wrong number of arguments provided to configure-aws-credentials-oidc.sh"
  exit 1
fi

account=$1
region=$2
role_name=$3

echo "account=${account}"
echo "region=${region}"
echo "role_name=${role_name}"

export AWS_ROLE_ARN="arn:aws:iam::${account}:role/${role_name}"
export AWS_WEB_IDENTITY_TOKEN_FILE=/tmp/awscreds
export AWS_DEFAULT_REGION="${region}"

echo "AWS_WEB_IDENTITY_TOKEN_FILE=${AWS_WEB_IDENTITY_TOKEN_FILE}" >> "${GITHUB_ENV}"
echo "AWS_ROLE_ARN=${AWS_ROLE_ARN}" >> "${GITHUB_ENV}"
echo "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" >> "${GITHUB_ENV}"

curl -H "Authorization: bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" "${ACTIONS_ID_TOKEN_REQUEST_URL}" | jq -r '.value' > "${AWS_WEB_IDENTITY_TOKEN_FILE}"

aws sts get-caller-identity
