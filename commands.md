# Useful Terraform Commands

## Initialization
```sh
terraform init
```
Initializes a Terraform working directory.

## Formatting
```sh
terraform fmt
```
Formats Terraform configuration files.

## Validation
```sh
terraform validate
```
Validates the configuration files.

## Plan
```sh
terraform plan
```
Shows changes required by the current configuration.

## Apply
```sh
terraform apply
```
Applies the changes required by the configuration. Flags: 

## Destroy
```sh
terraform destroy
```
Destroys the managed infrastructure.

## Show State
```sh
terraform show
```
Displays the current state or a saved plan.

## Output
```sh
terraform output
```
Shows output values from the state file.

## List Resources
```sh
terraform state list
```
Lists resources in the state file.

## Graph Visualization
```sh
terraform graph | dot -Tpng -o graph.png
```
Generates a visual dependency graph of resources and saves it as a PNG image. (dnf install dot)

