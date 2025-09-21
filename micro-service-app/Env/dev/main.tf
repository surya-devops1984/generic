module "rg" {
  source = "../../General_Modual/1Resource Group"
  for_each = var.rg
  rg_name = each.value.name
  rg_location = each.value.location
}
