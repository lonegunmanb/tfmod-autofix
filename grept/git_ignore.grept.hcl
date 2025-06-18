locals {
  ignored_items = toset([
    ".terraform.lock.hcl",
    ".terraformrc",
    "*.tfstate.*",
    "*.tfstate",
    "*.tfvars.json",
    "*.tfvars",
    "**/.terraform/*",
    "*tfplan*",
    "tflint.hcl",
    "tflint.merged.hcl",
    "crash.*.log",
    "crash.log",
    ".DS_Store",
    "*.md.tmp",
    "policy/*",
  ])
}

data "git_ignore" "current_ignored_items" {}

rule "must_be_true" "essential_ignored_items" {
  condition = length(compliment(local.ignored_items, data.git_ignore.current_ignored_items.records)) == 0
}

fix "git_ignore" "ensure_ignore" {
  rule_ids = [rule.must_be_true.essential_ignored_items.id]
  exist    = local.ignored_items
}