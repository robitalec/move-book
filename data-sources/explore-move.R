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

# Get details
details <- rbindlist(lapply(studies, getMovebankStudy, login = login))

# Movebank has no automated/complete database to download
# Therefore, we'll loop through all the studies, get the details,
# and summarize how much data is actually accessible
