# GitHub Actions Terraform AWS labbing

## Usage
1. Update variables and provider configuration under terraform_backend accordingly
2. Run terraform init + apply from terraform_backend folder to provision backend resources
3. Update env variables in the workflow files under .github/workflows according to step 1
4. Update backend configurations per environment accordingly (versions.tf)

## Actions workflow
* Terraform plan triggers on changes pushed to any branch != “main”
* Terraform plan PR triggers when a new pull request is opened against the main branch
* Terraform apply triggers on changes pushed to the main branch
* Terraform destroy runs on schedule at 18:00 each day