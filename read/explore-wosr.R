# Explore wosr, etc bib pkgs ----------------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
# install.packages("wosr")
library(wosr)

library(keyring)


# Credentials -------------------------------------------------------------
service = 'wosr'
username = 'robit.alec@gmail.com'

# key_set(service = service, username = username)

Sys.setenv(WOS_USERNAME = username, WOS_PASSWORD = key_get(service, username))



# Query -------------------------------------------------------------------


