# clone_elemental_proxmox
Quickly clone ElementalOS templates in Proxmox for Rancher Deployment



Usage: ./clone_elemental.sh <nodeType> <templateId> <storageName> <diskSize>
  nodeType     - Type of node to create ('mgr' for manager, 'wrk' for worker)
  templateId   - Numeric ID of the template to clone
  storageName  - Name of the storage to use
  diskSize     - Disk size in the format '32G' (e.g., size followed by 'G')
