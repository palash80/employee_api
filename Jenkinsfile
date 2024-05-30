pipeline {
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    parameters {
        string(name: 'action', defaultValue: 'plan', description: 'Action to perform: plan, apply, or destroy')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo "Cleaning workspace..."
                cleanWs()
                echo "Workspace cleaned."
            }
        }

        stage('Checkout') {
            steps {
                echo "Checking out the repository..."
                script {
                    git branch: 'main', credentialsId: 'palash-git', url: 'https://github.com/palash80/employee_api.git'
                }
                echo "Repository checked out."
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh 'pwd; terraform init'
                echo "Terraform initialization complete."
            }
        }

        stage('Terraform Action') {
            steps {
                echo "Terraform action is -> ${params.action}"

                script {
                    if (params.action == 'plan') {
                        echo "Running terraform plan..."
                        sh 'terraform plan -out tfplan'
                        echo "Terraform plan completed."
                    } else if (params.action == 'apply') {
                        echo "Running terraform apply..."
                        sh 'terraform apply -auto-approve'
                        echo "Terraform apply completed."
                    } else if (params.action == 'destroy') {
                        echo "Running terraform destroy..."
                        sh 'terraform destroy -auto-approve'
                        echo "Terraform destroy completed."
                    } else {
                        error "Invalid action: ${params.action}. Supported actions are 'plan', 'apply', and 'destroy'."
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
            echo 'Workspace cleanup complete.'
        }
    }
}
