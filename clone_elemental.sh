#!/bin/bash

# Input parameters
nodeType=$1
templateId=$2
storageName=$3
diskSize=$4

# Usage guide
usage() {
    echo "Usage: $0 <nodeType> <templateId> <storageName> <diskSize>"
    echo "  nodeType     - Type of node to create ('mgr' for manager, 'wrk' for worker)"
    echo "  templateId   - Numeric ID of the template to clone"
    echo "  storageName  - Name of the storage to use"
    echo "  diskSize     - Disk size in the format '32G' (e.g., size followed by 'G')"
    exit 1
}

# Validate nodeType is provided and is either "mgr" or "wrk"
if [[ -z "$nodeType" ]]; then
    echo "Error: nodeType must be provided."
    usage
fi

if [[ "$nodeType" != "mgr" && "$nodeType" != "wrk" ]]; then
    echo "Error: nodeType must be either 'mgr' or 'wrk'."
    usage
fi

# Check if all inputs are provided
if [[ -z "$templateId" || -z "$storageName" || -z "$diskSize" ]]; then
    echo "Error: Missing input parameters."
    usage
fi

# Validate templateId is numeric
if ! [[ "$templateId" =~ ^[0-9]+$ ]]; then
    echo "Error: templateId must be a numeric value."
    usage
fi

# Validate diskSize matches the pattern (e.g., "32G")
if ! [[ "$diskSize" =~ ^[0-9]+[G]$ ]]; then
    echo "Error: diskSize must be in the format '32G' (e.g., size followed by 'G')."
    usage
fi

# Ensure storageName is provided
if [[ -z "$storageName" ]]; then
    echo "Error: storageName must be provided."
    usage
fi

newId="$(pvesh get /cluster/nextid)"
newHostname="el${nodeType}${newId}"

if [[ "$nodeType" == "wrk" ]]; then
    longNodeType="Worker"
elif [[ "$nodeType" == "mgr" ]]; then
    longNodeType="Manager"
fi

echo "Creating new longNodeType node $newHostname from Template ID $templateId with $diskSize drive on $storageName..."

currentDateTime=$(date '+%Y-%m-%d %H:%M:%S')

qm clone $templateId $newId --description "Elemental $longNodeType Node, provisioned at $currentDateTime" --name $newHostname --storage $storageName --full true
qm resize $newId scsi0 $diskSize
qm set $newId --smbios1 serial=$newHostname
