pipeline {
                    environment {
                        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                    }

                    agent any

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
                                    dir("terraform") {
                                        git branch: 'Dev', credentialsId: 'palash-git', url: 'https://github.com/palash80/employee_api.git'
                                        
                                    }
                                }
                                echo "Repository checked out."
                            }
                        }

                        stage('Terraform Init') {
                            steps {
                                echo "Initializing Terraform..."
                                sh 'pwd; cd ${WORKSPACE}/terraform/Jenkinsfile; terraform init'
                                echo "Terraform initialization complete."
                            }
                        }

                        stage('Terraform Action') {
                            steps {
                                echo "Terraform action is -> ${action}"

                                script {
                                    // Check the value of ${action} and execute the appropriate Terraform command
                                    if (action == 'plan') {
                                        echo "Running terraform plan..."
                                        sh "cd ${WORKSPACE}/terraform/Jenkinsfile && terraform plan -out tfplan"
                                        echo "Terraform plan completed."
                                    } else if (action == 'apply') {
                                        echo "Running terraform apply..."
                                        sh "cd ${WORKSPACE}/terraform/Jenkinsfile && terraform apply -auto-approve"
                                        echo "Terraform apply completed."
                                    } else if (action == 'destroy') {
                                        echo "Running terraform destroy..."
                                        sh "cd ${WORKSPACE}/terraform/Jenkinsfile && terraform destroy -auto-approve"
                                        echo "Terraform destroy completed."
                                    } else {
                                        error "Invalid action: ${action}. Supported actions are 'plan', 'apply', and 'destroy'."
                                    }
                                }
                            }
                        }
                    }
                }
