library(targets)


# Source functions
source('scripts/functions.R')


# Set target-specific options such as packages.
# tar_option_set()


# Paths
if (.Platform$OS.type == "windows") {
	downpath <- file.path('E:', 'ALR_C2', 'All')
	outpath <- file.path('E:', 'ALR_C2', 'Summary')
} else if (.Platform$OS.type == "unix") {
	downpath <- file.path('/media', 'ICEAGE', 'Movebank', 'All')
	outpath <- file.path('/media', 'ICEAGE', 'Movebank', 'Summary', 'All')
}


# End this file with a list of target objects.
list(
	tar_target(csvs, dir(downpath), format = 'file')
)
