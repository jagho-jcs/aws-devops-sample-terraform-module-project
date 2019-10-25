pipeline {

    agent any
    parameters {
        
        booleanParam(name: 'create_vpc', 
        defaultValue: true,
        description: 'Controls if VPC should be created (it affects almost all resources)' )
        
        string(name: 'aws_region', 
        defaultValue: 'eu-west-1',
        description: 'Where would you like to deploy your VPC?.. Examples eu-west-1, eu-west-2' )
    
        string(name: 'cidr', 
        defaultValue: '0.0.0.0/0',
        description: 'The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden' )

        string(name: 'azs', 
        defaultValue: '',
        description: 'Availability Zones' )



        string(name: 'aws_alb_tgt_grp_att_port', 
        defaultValue: '8080',
        description: 'attachment port' )

        string(name: 'aws_alb_target_group_port', 
        defaultValue: '8080',
        description: 'Target group port' )        

        string(name: 'aws_alb_listener_port', 
        defaultValue: '80',
        description: 'Application Load Balancer Listener Port' )
    }
    environment {
        
        TF_HOME = tool('terraform-0.12.12')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
        // JKS_AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        // JKS_AWS_SECRET_ACCESS = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "${params.aws_region}"
        AWS_ACCESS_KEY_ID = "${JKS_AWS_ACCESS_KEY}"
        AWS_SECRET_ACCESS_KEY = "${JKS_AWS_SECRET_ACCESS}"
    }

    stages {

        stage('my params') {

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

                sh 'terraform -version'
            }
        }
        stage ('Provision VPC') {
            
            steps {

            // environment {

            //     region = 
            // }
                
                dir ('example')
                
                {
                    
                    sh "terraform init"
                    sh 'terraform plan \
                        -var="create_vpc=${create_vpc}" \
                        -var="region=${aws_region}" \
                        -var="aws_alb_tgt_grp_att_port=${aws_alb_tgt_grp_att_port}" \
                        -var="aws_alb_target_group_port=${aws_alb_target_group_port}" \
                        -var="aws_alb_listener_port=${aws_alb_listener_port}" \
                        -var="cidr=${cidr}" \
                        -var="azs=${azs}"'
                }
            }
        }
    }
}