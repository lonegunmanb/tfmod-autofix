data "terraform" this {}

locals {
  is_terraform_block_in_right_file = try(
    data.terraform.this.block.mptf.range.file_name == "terraform.tf",
    true
  )
}

transform "move_block" "incorrect_terraform_block" {
  for_each = local.is_terraform_block_in_right_file ? toset([]) : toset([1])
  target_block_address = "terraform"
  file_name = "terraform.tf"
}