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

To interact with the fleet you will use the `kubectl` command. The credentials for `kubectl` are retrieved like this:

```
az fleet get-credentials --resource-group ${GROUP} --name ${FLEET}
```

You can test the credentials are working retrieving the list of clusters in the fleet:
```
kubectl get memberclusters
```

This command might fail with a permission error if you had run Terraform with a different identity than the one you are using to authenticate with `kubectl`.

This Terraform project will assign to the identity running Terraform the role `Azure Kubernetes Fleet Manager RBAC Cluster Admin` on the fleet resource.

If you want to assign the role to a different identity you can use the following commands:

```
export FLEET_ID=$(az fleet show -g fleet_rg_1 --name contosofleet -o json | jq -r .id)
# This is an example, you can use any identity you want, this specific one is already assigned the role by Terraform
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

