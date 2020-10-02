# === Explore rmoveapi ----------------------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
# remotes::install_github('benscarlson/rmoveapi')
library(data.table)
library(rmoveapi)
library(keyring)


# Data --------------------------------------------------------------------
details <- fread('data-sources/details.csv')
DT <- fread('data-sources/taxed-details.csv')


# Credentials -------------------------------------------------------------
service = 'movebank'
username = 'robitalec'


# Explore -----------------------------------------------------------------
setAuth(key_list(service)[1, 2], key_get(service, username))


ustudies <- unique(DT, by = 'id')
mammals <- ustudies[class == 'Mammalia']

mammals[, tryCatch(
	getEvent(
		studyid = .BY[[1]],
		attributes = 'all',
		save_as = paste0('/media/Backup Plus/Movebank/Mammalia/', .BY[[1]], '.csv'),
		accept_license = TRUE
	),
	error = function(e)
		NULL
), by = id]


#          id     V1
#          <int> <lgcl>
# 1:    3072183   TRUE
# 2:   36994467   TRUE
# 3: 1260886163   TRUE
# 4:   11212867   TRUE
# 5:  302664172   TRUE
# ---
# 375:  313789633   TRUE
# 376: 1109134970   TRUE
# 377:  268904527   TRUE
# 378:  259966228   TRUE
# 379:   32425920   TRUE
# There were 50 or more warnings (use warnings() to see the first 50)
# R: warnings()
# Warning messages:
# 1: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/3072183.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 2: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/36994467.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 3: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/11212867.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 4: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/1061046330.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 5: closing unused connection 15 (/media/Backup Plus/Movebank/Mammalia/1061046330.csv)
# 6: closing unused connection 14 (/media/Backup Plus/Movebank/Mammalia/178994931.csv)
# 7: closing unused connection 13 (/media/Backup Plus/Movebank/Mammalia/143848765.csv)
# 8: closing unused connection 12 (/media/Backup Plus/Movebank/Mammalia/302664172.csv)
# 9: closing unused connection 11 (/media/Backup Plus/Movebank/Mammalia/11212867.csv)
# 10: closing unused connection 10 (/media/Backup Plus/Movebank/Mammalia/1260886163.csv)
# 11: closing unused connection 9 (/media/Backup Plus/Movebank/Mammalia/36994467.csv)
# 12: closing unused connection 8 (/media/Backup Plus/Movebank/Mammalia/3072183.csv)
# 13: closing unused connection 7 (/media/Backup Plus/Movebank/Mammalia/11212867)
# 14: closing unused connection 6 (/media/Backup Plus/Movebank/Mammalia/1260886163)
# 15: closing unused connection 5 (/media/Backup Plus/Movebank/Mammalia/36994467)
# 16: closing unused connection 4 (/media/Backup Plus/Movebank/Mammalia/3072183)
# 17: closing unused connection 3 (/media/Backup Plus/Movebank/Mammalia/3072183)
# 18: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/5506230.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 19: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/8019372.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 20: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/662993476.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 21: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/612917076.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 22: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/1060755618.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 23: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/17241829.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 24: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/368922919.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 25: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/368049215.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 26: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/920007556.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 27: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/467034665.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 28: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/467031755.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 29: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/59069076.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 30: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/72289508.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 31: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/106101649.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 32: In readLines(file(save_as, open = "r"), n = 1) :
# incomplete final line found on '/media/Backup Plus/Movebank/Mammalia/452187673.csv'
# Calls: [ ... doTryCatch -> getEvent -> getGeneric -> getMvData -> readLines
# 33: In for (i in seq_len(n)) { ... :
# closing unused connection 24 (/media/Backup Plus/Movebank/Mammalia/1027467132.csv)
# 34: In for (i in seq_len(n)) { ... :
# closing unused connection 23 (/media/Backup Plus/Movebank/Mammalia/33988628.csv)
# 35: In for (i in seq_len(n)) { ... :
# closing unused connection 22 (/media/Backup Plus/Movebank/Mammalia/33987894.csv)
# 36: In for (i in seq_len(n)) { ... :
# closing unused connection 21 (/media/Backup Plus/Movebank/Mammalia/452187673.csv)
# 37: In for (i in seq_len(n)) { ... :
# closing unused connection 20 (/media/Backup Plus/Movebank/Mammalia/650188969.csv)
# 38: In for (i in seq_len(n)) { ... :
# closing unused connection 19 (/media/Backup Plus/Movebank/Mammalia/106101649.csv)
# 39: In for (i in seq_len(n)) { ... :
# closing unused connection 18 (/media/Backup Plus/Movebank/Mammalia/72289508.csv)
# 40: In for (i in seq_len(n)) { ... :
# closing unused connection 17 (/media/Backup Plus/Movebank/Mammalia/59069076.csv)
# 41: In for (i in seq_len(n)) { ... :
# closing unused connection 16 (/media/Backup Plus/Movebank/Mammalia/229457444.csv)
# 42: In for (i in seq_len(n)) { ... :
# closing unused connection 15 (/media/Backup Plus/Movebank/Mammalia/467031755.csv)
# 43: In for (i in seq_len(n)) { ... :
# closing unused connection 14 (/media/Backup Plus/Movebank/Mammalia/467034665.csv)
# 44: In for (i in seq_len(n)) { ... :
# closing unused connection 13 (/media/Backup Plus/Movebank/Mammalia/920007556.csv)
# 45: In for (i in seq_len(n)) { ... :
# closing unused connection 12 (/media/Backup Plus/Movebank/Mammalia/368049215.csv)
# 46: In for (i in seq_len(n)) { ... :
# closing unused connection 11 (/media/Backup Plus/Movebank/Mammalia/368922919.csv)
# 47: In for (i in seq_len(n)) { ... :
# closing unused connection 10 (/media/Backup Plus/Movebank/Mammalia/17241829.csv)
# 48: In for (i in seq_len(n)) { ... :
# closing unused connection 9 (/media/Backup Plus/Movebank/Mammalia/1060755618.csv)
# 49: In for (i in seq_len(n)) { ... :
# closing unused connection 8 (/media/Backup Plus/Movebank/Mammalia/612917076.csv)
# 50: In for (i in seq_len(n)) { ... :
# closing unused connection 7 (/media/Backup Plus/Movebank/Mammalia/662993476.csv)
# There were 11 warnings (use warnings() to see them)
