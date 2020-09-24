# === Explore move(bank) --------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
# install.packages('move')
library(move)

library(data.table)


# Credentials -------------------------------------------------------------
# install.packages('keyring')

service = 'movebank'
username = 'robitalec'


# keyring::key_set(service = service, username = username)

library(keyring)


# Explore -----------------------------------------------------------------
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))

# Get all the studies
studies <- getMovebankStudies(login)

# Movebank has no automated/complete database to download
# Therefore, we'll loop through all the studies, get the details,
# and summarize how much data is actually accessible
details <- rbindlist(lapply(studies, getMovebankStudy, login = login))

# Error: There was more than one study with the name: X
# How many times does this occur? 17 unique studies, 88 rows (2020-09-04)
morethanone <- data.table(study = studies)[, .N, by = study][N > 1]

# Only unique studies
substudies <- studies[!studies %in% morethanone$study &
												!grepl('Test', studies)]
details <- rbindlist(lapply(substudies, getMovebankStudy, login = login),
										 fill = TRUE, use.names = TRUE)

saveRDS(details, 'data-sources/details.Rds')

# From: https://github.com/benscarlson/rmoveapi
# Certain studies require you to accept license terms before downloading any data. One way to do this is to accept these terms on movebank.com. Terms can also be accepted over the api by using accept_license=TRUE in the request for data.

