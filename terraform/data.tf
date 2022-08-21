data "aws_subnets" "all_vps_subnet" {
    tags = {
      filter_tag = "vpc-terra-infta-subnet"
    }
}

data "aws_subnet" "all_vps_subnet" {
  for_each = toset(data.aws_subnets.all_vps_subnet.ids)
  id       = each.value
}

output "all_sunmets" {
  value =[for s in data.aws_subnet.all_vps_subnet : s.cidr_block]

}
output "all_sunmets_ids" {
  value =[for s in data.aws_subnet.all_vps_subnet : s.id]

}