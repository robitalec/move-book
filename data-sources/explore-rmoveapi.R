# === Explore rmoveapi ----------------------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
# remotes::install_github('benscarlson/rmoveapi')
library(rmoveapi)
library(keyring)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')


# Credentials -------------------------------------------------------------
service = 'movebank'
username = 'robitalec'


# Explore -----------------------------------------------------------------
setAuth(key_list(service)[1, 2], key_get(service, username))

rmoveapi:::
