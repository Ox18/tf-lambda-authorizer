resource "aws_api_gateway_rest_api" "demo" {
    name = "auth-terraform"
}

resource "aws_api_gateway_authorizer" "demo" {
    name                    = "api_gateway_authorizer-terraform"
    rest_api_id             = aws_api_gateway_rest_api.demo.id
    authorizer_uri          = aws_lambda_function.authorizer.invoke_arn
    authorizer_credentials  = aws_iam_role.invocation_role.arn

    depends_on = [
        aws_lambda_function.authorizer,
        aws_iam_role.invocation_role
    ]
}
resource "aws_iam_role" "invocation_role" {
    name = "api_gateway_auth_invocation_rol-terraform"
    path = "/"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "invocation_policy" {
    name = "api_gateway_auth_invocation_policy-terraform"
    role = aws_iam_role.invocation_role.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "lambda:InvokeFunction",
            "Effect": "Allow",
            "Resource": "${aws_lambda_function.authorizer.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "lambda" {
    name = "lambda_rol-terraform"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_lambda_function" "authorizer" {
    filename         = "lambda.zip"
    function_name    = "api_gateway_authorizer-terraform"
    role             = aws_iam_role.lambda.arn
    handler          = "handler.handler"
    runtime          = "nodejs18.x"
    package_type     = "Zip"
    source_code_hash = filebase64sha256("lambda.zip")
}