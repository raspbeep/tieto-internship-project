# TODO: do kazdeho skriptu pridat descriptive logs

all: image terraf loadbal database k3sinstall

dash:
	# TODO: this
	echo 'hello'

terraf:
	cd tf; bash ./terraform_setup.sh

image:
	cd image_builder; bash ./builder.sh

k3sinstall:
	cd k3s_install; bash ./k3s_setup.sh

loadbal:
	cd load_bal_config; bash ./balancer_setup.sh

database:
	cd db_config; bash ./secure_install.sh

clean:
	cd tf; terraform destroy -auto-approve
	cd tf; rm -rf .terraform/; rm -rf .terraform.lock.hcl; rm -rf terraform.tfstate
	