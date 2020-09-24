# === Explore move(bank) --------------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
# install.packages('move')
library(move)



# Credentials -------------------------------------------------------------
# install.packages('keyring')

# keyring::key_set(service = 'movebank',
# 								 username = 'robitalec')

library(keyring)



# Explore -----------------------------------------------------------------
movebankLogin(key_list)
# Get all the studies
studies <- getMovebankStudies()
