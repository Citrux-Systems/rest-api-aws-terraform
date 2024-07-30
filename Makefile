node_pkg:
	@echo "test node pkg"
	rm -rf dist && npx tsc && \
	cp -r node_modules dist/ && \
	cd dist && zip -r test-lambda.zip .

apply:
	@echo "Starting Terraform apply process..."
	cd terraform && terraform apply

init:
	@echo terraform init
	cd terraform && terraform init

plan:
	@echo terraform plan
	cd terraform && terraform plan

destroy:
	@echo terraform destroy
	cd terraform && terraform destroy

validate:
	@echo terraform validate
	cd terraform && terraform validate