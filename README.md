# RESTAPI AWS | TERRAFORM

> [!IMPORTANT]
> To learn how this repository works, see our blog > [Step-by-Step Guide: Deploying a REST API in AWS with Terraform](https://citruxdigital.com/blog/step-by-step-guide-deploying-a-rest-api-in-aws-with-terraform).

<!-- Terraform -->

## Terraform

This project is a terraform project that creates an AWS Lambda function and an API Gateway to trigger the lambda function.

## Pre requirements

AWS CLI must be configured with the credentials of the account that will be used to create the resources.

## Requirements

- Terraform
- AWS CLI
- Make
- Node.js
- NPM
- Typescript

## How to run

1. Clone the repository
2. Run `npm install`
3. Run `make node_pkg`
4. Run `make init`
5. Run `make plan`
6. Run `make apply`

## How to test

1. Go to the AWS Console
2. Go to the API Gateway service
3. Click on the API that was created
4. Click on any of the resources


## Commands

<details>
<summary>Terraform</summary>

```
terraform init
```

#### Description

Initialize the terraform project

```
terraform plan
```

#### Description

Show the changes that will be applied

```
terraform apply
```

#### Description

Apply the changes

```
terraform destroy
```

#### Description

Destroy the resources

```
terraform validate
```

#### Description

Validate the terraform files

</details>

<details>
  <summary>Make</summary>

```
make node_pkg
```

#### Description

Remove folder dist, run typescript init, copy the node_modules to dist folder and zip the dist folder

```
make apply
```

#### Description

Run terraform apply

```
make init
```

#### Description

Run terraform init

```
make plan
```

#### Description

Run terraform plan

```
make destroy
```

#### Description

Run terraform destroy

```
make validate
```

#### Description

Run terraform validate

</details>
