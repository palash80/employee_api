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
                                        git branch: 'Dev', credentialsId: 'nida-git', url: ''
                                        sh 'chmod +x Dev_Infrastructure/tf_static/python'
                                    }
                                }
                                echo "Repository checked out."
                            }
                        }

                        stage('Terraform Init') {
                            steps {
                                echo "Initializing Terraform..."
                                sh 'pwd; cd ${WORKSPACE}/terraform/Dev_Infrastructure/tf_static/python; terraform init'
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
                                        sh "cd ${WORKSPACE}/terraform/Dev_Infrastructure/tf_static/python && terraform plan -out tfplan"
                                        echo "Terraform plan completed."
                                    } else if (action == 'apply') {
                                        echo "Running terraform apply..."
                                        sh "cd ${WORKSPACE}/terraform/Dev_Infrastructure/tf_static/python && terraform apply -auto-approve"
                                        echo "Terraform apply completed."
                                    } else if (action == 'destroy') {
                                        echo "Running terraform destroy..."
                                        sh "cd ${WORKSPACE}/terraform/Dev_Infrastructure/tf_static/python && terraform destroy -auto-approve"
                                        echo "Terraform destroy completed."
                                    } else {
                                        error "Invalid action: ${action}. Supported actions are 'plan', 'apply', and 'destroy'."
                                    }
                                }
                            }
                        }
                    }
                }
