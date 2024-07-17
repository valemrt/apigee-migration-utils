# Apigee Organization Migration Tool
This script provides a streamlined way to export resources from one Apigee organization and deploy them into another. It can be used for backup and restore operations or for migrating environments between organizations.

**Disclaimer:** This is not an official Google product. It is a community-developed tool and should be used with caution, especially in production environments. Always test thoroughly before deploying to live systems.

## Features
* Export: Creates a local backup of your Apigee organization's configuration, including API proxies and shared flows.
* Import: Restores the exported configuration into a different Apigee organization.
* Selective Deployment: Allows you to choose which proxies and shared flows to deploy.
* Error Handling: Detects and reports deployment errors, enabling you to address them manually.
## Prerequisites
* Apigee Account: You must have valid Apigee accounts for both the source and target organizations.
* `apigeecli`: This tool relies on the apigeecli command-line interface. Ensure it's installed and configured.
Installation instructions: https://github.com/apigee/apigeecli
* Google Cloud SDK: If you want to use Google Cloud application default credentials, you'll need the Google Cloud SDK.
Installation instructions: https://cloud.google.com/sdk/docs/install

## Usage
1. Clone the Repository:
```
git clone https://github.com/your-username/apigee-migration-utils.git
cd apigee-migration-utils
```

2. Replace Environment Variables:
```
export ORG_FROM=your_source_organization
export ORG_TO=your_target_organization
export ENV=your_target_environment 
export DEPLOY=true  # Set to false to skip deployment
```

3. Export and Import (Optional):

Uncomment the export/import section in the script if you want to create and restore a full backup.
4. Run the Script:
```
./apigee_migrate.sh
```

The script will prompt you to confirm the deployment to the target environment.

## Notes
* **Error Handling**
If any deployments fail, the script will provide a list of the problematic resources at the end of its execution. Review the Apigee UI or logs for more details and address the issues manually.

* **Contributing**
Contributions are welcome! Please feel free to open issues or submit pull requests.

* **Support:** This script is not officially supported by Google. Use it at your own risk.
