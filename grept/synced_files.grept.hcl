locals {
  github_token = env("GITHUB_TOKEN")
  common_http_headers = local.github_token == "" ? {} : {
    Authorization = "Bearer ${local.github_token}"
  }
  synced_files = toset([
  ])
  url_prefix        = "https://raw.githubusercontent.com/lonegunmanb/tfmod-autofix/main"
}

data "http" "synced_files" {
  for_each = local.synced_files

  request_headers = merge({}, local.common_http_headers)
  url             = "${local.url_prefix}/${each.value}"
}

rule "file_hash" "synced_files" {
  for_each = local.synced_files

  glob = each.value
  hash = sha1(data.http.synced_files[each.value].response_body)
}

fix "local_file" "synced_files" {
  for_each = local.synced_files

  rule_ids = [rule.file_hash.synced_files[each.value].id]
  paths    = [each.value]
  content  = data.http.synced_files[each.value].response_body
}