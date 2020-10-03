# === Downloaded Dataset Details ------------------------------------------
# Alec Robitaille



# Packages ----------------------------------------------------------------
library(data.table)


# Data --------------------------------------------------------------------
size <- vapply(dir('/media/Backup Plus/Movebank/GPS', full.names = TRUE), file.size, 1)
nm <- tstrsplit(dir('/media/Backup Plus/Movebank/GPS'), '.csv')[[1]]

data <- data.table(sizes, nms)
