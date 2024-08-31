variable "buildspecpath" {
  default = "buildspec.yml"
  type    = string
}

variable "GitHubBranch" {
  default = "main"
  type    = string
}

variable "GitHubOwner" {
  default = "ferdowsahmady"
  type    = string
}

variable "GitHubRepo" {
  default = "terraform-final-project"
  type    = string
}

variable "GitHubToken" {
  type = string
  default = null
}

resource "aws_codepipeline" "codepipeline" {
  name     = "final-project-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  depends_on = [ aws_codestarconnections_connection.example ]

  artifact_store {
    location = aws_s3_bucket.example.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "rpaskalev/terraform-final-project"
        BranchName       = "troubleshoot/cicd"
        # OAuthToken = data.aws_ssm_parameter.git-token-terraform-project.value 
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "codebuild-project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = "app1Deploy"
        DeploymentGroupName = "app1DeploymentGroup"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "example" {
  name          = "example-connection"
  provider_type = "GitHub"
}