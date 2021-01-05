library(targets)
library(tarchetypes)

# Source functions
source('scripts/functions.R')


# Packages
library(data.table)
library(rmoveapi)
library(keyring)
library(move)
library(taxize)
library(anytime)


# for missing pipe in rmoveapi (?)
library(magrittr)

# Paths
if (.Platform$OS.type == "windows") {
	downpath <- file.path('E:', 'ALR_C2', 'All')
	outpath <- file.path('E:', 'ALR_C2', 'Summary')
} else if (.Platform$OS.type == "unix") {
	downpath <- file.path('/media', 'ICEAGE', 'Movebank', 'All')
	outpath <- file.path('/media', 'ICEAGE', 'Movebank', 'Summary', 'All')
}

# Credentials
service = 'movebank'
username = 'robitalec'
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))
options(rmoveapi.userid = key_list(service)[1, 2])
options(rmoveapi.pass = key_get(service, username))

# Ranks for taxize
ranks <- c('family', 'class')


# Targets: options
tar_option_set(error = "workspace", format = 'qs')

# Targets: workflow
list(
	tar_files(paths,
						sample(dir(downpath, '.csv', full.names = TRUE), 100)),

	tar_target(checked,
						 check_input(paths),
						 pattern = map(paths)),

	tar_target(filtered,
						 checked[is.na(why)]),

	tar_target(details,
						 setDT(get_details(filtered$id)),
						 pattern = map(filtered)),

	tar_target(taxed, resolve_taxon(details, filtered$id, ranks)),

	tar_target(merged, merge(filtered, taxed, by = 'id')),

	tar_target(read,
						 read_input(merged, ranks = ranks),
						 pattern = map(merged))
)
