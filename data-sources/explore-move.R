# === Explore move(bank) --------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
# install.packages('move')
library(move)



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
