# Explore move(bank)

install.packages('move')


library(move)


# Credentials
install.packages("keyring")

keyring::key_set(service = "movebank",
								 username = "robitalec")


# Get all the studies
studies <- getMovebankStudies()
