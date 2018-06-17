resource "aws_codepipeline" "website" {
  name     = "website-pipeline"
  role_arn = "${var.aws_iam_role_codepipeline_arn}"

  artifact_store {
    location = "${var.aws_s3_bucket_builds_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["website"]

      configuration {
        Owner                = "${var.github_organization}"
        Repo                 = "website"
        Branch               = "master"
        OAuthToken           = "${var.github_token}"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Test"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["website"]
      version         = "1"

      configuration {
        ProjectName = "website-test"
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
      input_artifacts  = ["website"]
      output_artifacts = ["dist"]
      version          = "1"

      configuration {
        ProjectName = "website-build"
      }
    }
  }
}
