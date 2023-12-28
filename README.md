# AKS fleet manager demo

This is a demo of [AKS Fleet Manager](https://learn.microsoft.com/en-gb/azure/kubernetes-fleet/)

## Architecture diagram

![diagram](/images/architecture_diagram.png)

## Run Terraform

```
cp tfvars .tfvars # customize values if needed
terraform init -upgrade
terraform apply -var-file=.tfvars -var-file=cosmos.tfvars
```

## Role assignments

TODO: this commands should be automated with Terraform

```
export FLEET_ID=$(az fleet show -g fleet_rg_1 --name contosofleet -o json | jq -r .id)
export IDENTITY=$(az ad signed-in-user show --query "id" --output tsv)
export ROLE="Azure Kubernetes Fleet Manager RBAC Cluster Admin"
az role assignment create --role "${ROLE}" --assignee ${IDENTITY} --scope ${FLEET_ID}
```

## Using AKS Fleet

With the infra created by Terraform you can jump to these 2 how-to guides:

* [Propagate Kubernetes resource objects from an Azure Kubernetes Fleet Manager resource to member clusters](https://learn.microsoft.com/en-gb/azure/kubernetes-fleet/configuration-propagation)
* [Set up multi-cluster layer 4 load balancing across Azure Kubernetes Fleet Manager member clusters](https://learn.microsoft.com/en-gb/azure/kubernetes-fleet/l4-load-balancing)

## Troubleshooting

When testing the multi-cluster layer 4 load balancing you might want to see the endpoints that are spread in the multiple clusters.
You can do that from the hub cluster, you will find a namespace created for each member cluster. Example:

```
KUBECONFIG=fleet kubectl get endpointsliceimports -n fleet-member-<member-name> -o yaml
```

To quickly see the all the endpoints you can use the following query:
```
KUBECONFIG=fleet kubectl get endpointsliceimports -A -o json | jq '.items[] | {clusterId: .spec.endpointSliceReference.clusterId, namespacedName: .spec.endpointSliceReference.namespacedName, endpoints: .spec.endpoints[].addresses}'

```

