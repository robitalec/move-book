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

substudies <- studies[!studies %in% morethanone$study]

