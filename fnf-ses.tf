resource "aws_sesv2_email_identity" "fnf-ses-email-identity" {
  email_identity = "sac.fast.n.foodious@gmail.com"
  configuration_set_name = aws_sesv2_configuration_set.fnf-ses-configuration-set.configuration_set_name
}

resource "aws_sesv2_configuration_set" "fnf-ses-configuration-set" {
    configuration_set_name = "fnf-ses-configuration-set"
    sending_options {
      sending_enabled = true
    }
}