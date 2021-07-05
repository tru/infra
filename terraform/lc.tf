locals {
  image_id          = "ami-0e565ccb9dda657e4"
  staging_image_id  = "ami-0e565ccb9dda657e4"
  beta_image_id     = "ami-0e565ccb9dda657e4"
  conan_image_id    = "ami-0b41dc7a318b530bd"
  staging_user_data = base64encode("staging")
  beta_user_data    = base64encode("beta")
  // Current c5 on-demand price is 0.085. Yearly pre-pay is 0.05 (so this is same as prepaying a year)
  // Historically we pay ~ 0.035
  spot_price        = "0.05"
}

resource "aws_launch_template" "CompilerExplorer-beta" {
  name                   = "ce-beta"
  description            = "Beta launch template"
  ebs_optimized          = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.CompilerExplorerRole.arn
  }
  image_id               = local.beta_image_id
  user_data              = local.beta_user_data
  key_name               = "mattgodbolt"
  vpc_security_group_ids = [aws_security_group.CompilerExplorer.id]
  instance_type          = "c5.large"

  tag_specifications {
    resource_type = "volume"

    tags = {
      Site = "CompilerExplorer"
      Environment = "Beta"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Site = "CompilerExplorer"
      Environment = "Beta"
      Name = "Beta"
    }
  }
}

resource "aws_launch_template" "CompilerExplorer-staging" {
  name                   = "ce-staging"
  description            = "Staging launch template"
  ebs_optimized          = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.CompilerExplorerRole.arn
  }
  image_id               = local.staging_image_id
  user_data              = local.staging_user_data
  key_name               = "mattgodbolt"
  vpc_security_group_ids = [aws_security_group.CompilerExplorer.id]
  instance_type          = "c5.large"

  tag_specifications {
    resource_type = "volume"

    tags = {
      Site = "CompilerExplorer"
      Environment = "Staging"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Site = "CompilerExplorer"
      Environment = "Staging"
      Name = "Staging"
    }
  }
}

resource "aws_launch_template" "CompilerExplorer-prod" {
  name                   = "ce-prod"
  description            = "Production launch template"
  ebs_optimized          = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.CompilerExplorerRole.arn
  }
  image_id               = local.image_id
  key_name               = "mattgodbolt"
  vpc_security_group_ids = [aws_security_group.CompilerExplorer.id]
  instance_type          = "c5.large"

  tag_specifications {
    resource_type = "volume"

    tags = {
      Site = "CompilerExplorer"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Site = "CompilerExplorer"
    }
  }
}
