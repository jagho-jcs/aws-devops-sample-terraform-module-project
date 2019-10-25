pipeline {

    agent any
    // parameters {
        
        // booleanParam(name: 'create_vpc', 
        //     defaultValue: true,
        //     description: 'Controls if VPC should be created (it affects almost all resources)')
        
        // string(name: 'aws_region', 
        //     defaultValue: 'eu-west-1',
        //     description: 'Where would you like to deploy your VPC?.. Examples eu-west-1, eu-west-2')
    
        // string(name: 'cidr', 
        //     defaultValue: '32.128.0.0/16',
        //     description: 'The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden')

        
        // choice(name: 'azs', 
        //     choices: ["eu-west-2a eu-west-2b eu-west-2c"],
        //     description: 'Availability Zones')

        // choice(name: 'public_subnets', 
        //     choices: ["32.128.112.0/20 32.128.128.0/20 32.128.144.0/20"], 
        //     description: 'A list of public subnets inside the VPC')



        // // choice(name: 'CHOICE''public_subnets', 
        // // defaultValue: ['32.128.112.0/20', '32.128.128.0/20', '32.128.144.0/20'],
        // // description: 'A list of public subnets inside the VPC')

        // choice(name: 'private_subnets', 
        //     choices: ["32.128.16.0/20 32.128.32.0/20 32.128.48.0/20"],
        //     description: 'A list of private subnets inside the VPC')

        // string(name: 'public_subnets', 
        // defaultValue: '',
        // description: 'A list of public subnets inside the VPC')

        // string(name: 'private_subnets', 
        // defaultValue: '',
        // description: 'A list of private subnets inside the VPC')

        // string(name: 'environment_tag', 
        //     defaultValue: 'Demo',
        //     description: 'Name of the Environment')

        // string(name: 'vpc_tags', 
        //     defaultValue: 'my-test-vpc',
        //     description: 'Additional tags for the VPC')

        // string(name: 'web_cluster_tag', 
        //     defaultValue: 'web_cluster',
        //     description: 'New Cluster name')

        // string(name: 'key_name', 
        //     defaultValue: 'hsbc_demo_web_cluster',
        //     description: 'Name of the Key Pair')

        // string(name: 'instance_type', 
        //     defaultValue: 't2.micro',
        //     description: 'Specify AMI Type') 

        // string(name: 'desired_capacity', 
        //     defaultValue: '3',
        //     description: 'Specify the number of instances to run in this Auto Scaling group')

        // string(name: 'min_size', 
        //     defaultValue: '1',
        //     description: 'The minimum number of instances the Auto Scaling group should have at any time') 

        // string(name: 'max_size', 
        //     defaultValue: '6',
        //     description: 'The maximum number of instances the Auto Scaling group should have at any time')

        // string(name: 'aws_alb_tgt_grp_att_port', 
        //     defaultValue: '8080',
        //     description: 'attachment port')

        // string(name: 'aws_alb_target_group_port', 
        //     defaultValue: '8080',
        //     description: 'Target group port')        

        // string(name: 'aws_alb_listener_port', 
        //     defaultValue: '80',
        //     description: 'Application Load Balancer Listener Port')
    // }
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

                // Remove the terraform state file so we always start from a clean state
                
                // if (fileExists(".terraform/terraform.tfstate")) {
                //     sh "rm -rf .terraform/terraform.tfstate"
                // }
            
                // if (fileExists("status")) {
                //     sh "rm status"
                // }
            }
        }
        stage ('Provision VPC') {
            
            steps {
                
                dir ('example')
                    // sh "terraform fmt -list=true -write=false -diff=true -check=true"
                {
                    sh "terraform fmt -list=true -write=false -diff=true -check=true"
                    sh "terraform init"
                    sh "terraform get"
                    sh "terraform apply -var-file=jcs_example_vpc_london.tfvars"
                    // sh 'terraform plan \
                    //     -var="region=${aws_region}" \
                    //     -var="cidr=${cidr}" \
                    //     -var="azs=${azs}" \
                    //     -var="public_subnets=${public_subnets}" \
                    //     -var="private_subnets=${private_subnets}" \
                    //     -var="environment_tag=${environment_tag}" \
                    //     -var="vpc_tags=${vpc_tags}" \
                    //     -var="key_name=${key_name}" \
                    //     -var="instance_type=${instance_type}" \
                    //     -var="desired_capacity=${desired_capacity}" \
                    //     -var="min_size=${min_size}" \
                    //     -var="max_size=${max_size}" \
                    //     -var="aws_alb_tgt_grp_att_port=${aws_alb_tgt_grp_att_port}" \
                    //     -var="aws_alb_target_group_port=${aws_alb_target_group_port}" \
                    //     -var="aws_alb_listener_port=${aws_alb_listener_port}"'
                }
            }
        }
    }
}