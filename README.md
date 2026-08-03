# cyber-range

The Range is a very WIP infrastructure as code style AWS environment. 

It is intended to be used for infosec training purposes including red/blue team simulations, incidence response training, etc.

Additionally, the range is meant to be ephemeral(ish) and destructible such that it can be spun up and down easily and state is reset upon initialization.

AWS Range Start:

1) terraform init
2) terraform plan
3) terraform apply -auto-approve

AWS Range Stop:
4) terraform destroy -auto-approve
