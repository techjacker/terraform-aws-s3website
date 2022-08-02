lockfiles: init
	@./bin/lockfiles

init:
	@terraform init -upgrade

plan:
	@terraform plan -out tf.plan

apply: plan
	@terraform apply tf.plan

.PHONY: plan apply init lockfiles
