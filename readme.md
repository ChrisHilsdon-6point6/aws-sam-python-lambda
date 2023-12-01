# AWS SAM Python Lambda
Example project to deploy Python Lambda using SAM with terraform.

You will need to have installed terrafrom and AWS CLI SAM.

main.py is a class that can be used on multiple lambdas. The example lambda is stored within the example_lambda folder which also includes requirements.txt. Terraform is configured to copy main.py file into the example_lambda folder before building.

Building using AWS SAM is done with py_build.sh which is coppied from the AWS example repo. Terraform is set to run the script which makes a zip file including python scripts and dependencies. The zip file is then used to create the lambda in AWS.

 - https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html
 - https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html