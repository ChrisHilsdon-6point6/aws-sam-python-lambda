locals {
  building_path = "build"
  example_lambda_name = "example_lambda"
  example_lambda_filename = "example_lambda.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_functions"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_basic" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "example_lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.example_lambda.function_name}"
}

resource "aws_lambda_function" "example_lambda" {
  function_name    = local.example_lambda_name
  filename         = "${path.module}/${local.building_path}/${local.example_lambda_filename}"
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.11"
  handler          = "${local.example_lambda_name}.lambda_handler"
  timeout          = 10
      depends_on = [
        null_resource.build_lambda_function
    ]
}

resource "null_resource" "sam_metadata_aws_example_lambda" {
  triggers = {
    resource_name = "${local.example_lambda_name}.lambda_handler"
    resource_type = "ZIP_LAMBDA_FUNCTION"
    original_source_code = "./example_lambda"
    built_output_path = "${local.building_path}/${local.example_lambda_filename}"
  }
  depends_on = [
    null_resource.build_lambda_function
  ]
}

resource "null_resource" "build_lambda_function" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command =  "./py_build.sh \"${local.example_lambda_name}\" \"${local.building_path}\" \"${local.example_lambda_filename}\" Function"
  }

  depends_on = [
    null_resource.example_lambda_copy_main
  ]
}

resource "null_resource" "example_lambda_copy_main" {
    provisioner "local-exec" {
        command =  "cp main.py ${local.example_lambda_name}/"
    }
}