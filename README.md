# AKS fleet manager demo

This is a demo of [AKS Fleet Manager](https://learn.microsoft.com/en-gb/azure/kubernetes-fleet/)

## Architecture diagram

![diagram](/images/architecture_diagram.png)

## Register the fleet preview feature

Run:
```
az feature register --namespace Microsoft.ContainerService --name FleetResourcePreview
```

Once the feature `FleetResourcePreview` is registered, invoking `az provider register -n Microsoft.ContainerService` is required to get the change propagated

Check for `registered` in the output:

```
az feature show  --namespace Microsoft.ContainerService --name FleetResourcePreview
```

once it is `registered` run:

```
az provider register -n Microsoft.ContainerService
```

## Run Terraform

```
cp tfvars .tfvars # customize values if needed
terraform init -upgrade
terraform apply -var-file=.tfvars -var-file=cosmos.tfvars
```
