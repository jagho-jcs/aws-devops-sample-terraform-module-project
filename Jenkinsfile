pipeline {

    agent any
    parameters {
                
        choice(name: 'aws_region', 
            choices: ['eu-west-1', 'eu-west-2', 'us-east-1'], 
            description: 'Where would you like to deploy your VPC?.. Examples eu-west-1, eu-west-2')
    }
    environment {

        AWS_DEFAULT_REGION = "${params.aws_region}"
        AWS_ACCESS_KEY_ID = "${JKS_AWS_ACCESS_KEY}"
        AWS_SECRET_ACCESS_KEY = "${JKS_AWS_SECRET_ACCESS}"
        TF_HOME = tool('terraform-0.12.12')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"

    }

    stages {

        stage('params') {

            steps {

                echo "You Selected: ${params.aws_region}"
            }
        }

        stage ('Checkout Repo') {

            steps {

                git branch: 'master',
                    credentialsId: 'e9ec2f9d-fa29-456d-b4e8-1f4001b4d4a2',
                    url: 'https://github.com/jagho-jcs/aws-devops-sample-terraform-module-project.git'
            }
        }

        stage ('Set Terraform Path') {

            steps {

                // Output Terraform Version 

                sh "terraform -version"

            }
        }
        stage ('Provision VPC') {
            
            steps {
                
                dir ('example')
                    
                {

                    sh "terraform init"
                    sh "terraform get"
                    sh 'terraform apply -var="region=${aws_region}" \
                        -var-file=jcs_example_vpc_london.tfvars -auto-approve'
                }
            }
        }
    }
}