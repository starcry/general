# list all running services
get-service <NAMING SUBSTRING> | where {$_.Status -eq "Running"} | format-table -auto


