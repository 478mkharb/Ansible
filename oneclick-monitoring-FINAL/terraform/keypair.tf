resource "aws_key_pair" "oneclick" {
  key_name   = "oneclick"
  public_key = file("${path.module}/keys/oneclick.pub")
}
