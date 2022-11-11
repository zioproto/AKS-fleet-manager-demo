variable "multi_region_write" {
  type        = bool
  description = "Cosmos Multi Region Flag"
  default     = true
}

variable "geo_locations" {
  type = list(object({
    geo_location      = string
    failover_priority = number
    zone_redundant    = bool
  }))
  description = "Cosmos geo location definitions"
  default = [
    {
      geo_location      = "eastus"
      failover_priority = 0
      zone_redundant    = false
    },
    {
      geo_location      = "westus"
      failover_priority = 1
      zone_redundant    = false
    }
  ]
}

variable "cosmos_account_name" {
  type        = string
  description = "Name of Cosmos DB Account"
  default     = "cosmos_sql_acc"
}

variable "cosmos_api" {
  type        = string
  description = "Cosmos API"
  default     = "sql"
}

variable "sql_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  description = "Cosmos databases definition"
}

variable "sql_db_containers" {
  type = map(object({
    container_name           = string
    db_name                  = string
    partition_key_path       = string
    partition_key_version    = number
    container_throughout     = number
    container_max_throughput = number
    default_ttl              = number
    analytical_storage_ttl   = number
    indexing_policy_settings = object({
      sql_indexing_mode = string
      sql_included_path = string
      sql_excluded_path = string
      composite_indexes = object({})
      spatial_indexes   = object({})
    })
    sql_unique_key = list(string)
    conflict_resolution_policy = object({
      mode      = string
      path      = string
      procedure = string
    })
  }))
  description = "Cosmos containers definition"
}