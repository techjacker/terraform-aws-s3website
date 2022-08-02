lockfile: tf-init
	@terraform providers lock \
  -platform=linux_amd64 \
  -platform=darwin_amd64

init:
	@terraform init -upgrade

plan:
	@terraform plan -out tf.plan

apply: plan
	@terraform apply tf.plan

.PHONY: plan apply init lockfile
