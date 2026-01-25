output "record_hostname" {
  description = "Full hostname of the DNS record"
  value       = cloudflare_record.resume.hostname
}

output "record_id" {
  description = "Cloudflare record ID"
  value       = cloudflare_record.resume.id
}

output "record_name" {
  description = "DNS record name"
  value       = cloudflare_record.resume.name
}