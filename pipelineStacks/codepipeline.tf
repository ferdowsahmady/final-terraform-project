variable "GitHubBranch" {
  default = "main"
  type    = string
}

variable "GitHubRepo" {
  default = "ferdowsahmady/terraform-final-project"
  type    = string
}

resource "aws_codepipeline" "codepipeline" {
  name     = "final-project-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  depends_on = [ aws_codestarconnections_connection.Github ]

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
        ConnectionArn    = aws_codestarconnections_connection.Github.arn
        FullRepositoryId = var.GitHubRepo
        BranchName       = var.GitHubBranch
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

resource "aws_codestarconnections_connection" "Github" {
  name          = "example-connection"
  provider_type = "GitHub"
}