#!/bin/bash

set -e

# Google Cloud authentication (uncomment if needed)
# gcloud auth application-default login

# Source and target Apigee organizations and deployment environment
export ORG_FROM=REPLACE
export ORG_TO=REPLACE
export DEPLOY=true
export ENV=REPLACE

# ---- Resource Export/Import ----

# Create backup directory
mkdir apigee_backup
cd apigee_backup

echo "Exporting resources in the organization $ORG_FROM ..."
apigeecli organizations export -o $ORG_FROM --default-token

echo "Importing resources in the organization $ORG_TO ..."
apigeecli organizations import -o $ORG_TO -f . --default-token


# ---- Deployment ----

set +e

failed_proxies=()
failed_sharedflows=()

if [ "$DEPLOY" = true ]; then

    # Input validation for deployment
    read -p "Are you sure you want to deploy to $ORG_TO in the $ENV environment? (y/n): " confirmation
    if [ "$confirmation" != "y" ]; then
        echo "Deployment canceled."
        exit 1  # Exit script with non-zero status to indicate cancellation
    fi

    echo "Deploying sharedflows..."
    for sharedflow in sharedflows/*.zip; do
        sharedflow_name=${sharedflow##*/}  # Extract filename from path
        sharedflow_name=${sharedflow_name%.*} # Remove file extension
        apigeecli sharedflows deploy -o "$ORG_TO" -e "$ENV" -n "$sharedflow_name" --default-token
        if [ $? -ne 0 ]; then
        echo "Error deploying sharedflow $sharedflow_name. Adding to list for manual review."
        failed_sharedflows+=("$sharedflow_name")
    fi
    done

    echo "Deploying proxies..."
    for proxy in proxies/*.zip; do
        proxy_name=${proxy##*/}  # Extract filename from path
        proxy_name=${proxy_name%.*} # Remove file extension
        apigeecli apis deploy -o "$ORG_TO" -e "$ENV" -n "$proxy_name" --default-token
        if [ $? -ne 0 ]; then
        echo "Error deploying $proxy_name. Adding to list for manual review."
        failed_proxies+=("$proxy_name")
    fi
    done

    if [ ${#failed_proxies[@]} -gt 0 ] || [ ${#failed_sharedflows[@]} -gt 0 ]; then
        echo "Deployment complete, but with errors. The following resources require manual intervention:"

        if [ ${#failed_proxies[@]} -gt 0 ]; then
            echo "Proxies:"
            for failed_proxy in "${failed_proxies[@]}"; do
                echo "- $failed_proxy"
            done
        fi
    
        if [ ${#failed_sharedflows[@]} -gt 0 ]; then
            echo "Sharedflows:"
            for failed_sharedflow in "${failed_sharedflows[@]}"; do
                echo "- $failed_sharedflow"
            done
        fi
    else
        echo "Deployment complete!"
    fi
else
    echo "DEPLOY variable not set to true. Skipping deployment."
fi