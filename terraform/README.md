# DevOps Project


## Pre-reqs
- Git, Docker, Maven installed locally
- AWS CLI configured (if using Terraform)
- Docker Hub account (or other registry)


## Steps
1. Clone repo, build locally (`mvn clean package`).
2. Build Docker image and test locally (`docker build -t <yourname>/demo:local .` then `docker run -p 8080:8080 ...`).
3. Push code to GitHub.
4. Configure Jenkins with credentials and create pipeline job.
5. Add Docker Hub credentials in Jenkins and EC2 SSH key.
6. Run Terraform to create infra (`terraform init` `terraform apply -var 'key_name=...` `-var 'public_key_path=~/.ssh/id_rsa.pub'`).
7. Update `Jenkinsfile` env.REGISTRY and EC2 host value in `scripts/deploy_via_ssh.sh`.
8. Push to GitHub and watch Jenkins pipeline.
