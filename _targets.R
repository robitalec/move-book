library(targets)


# Source functions
source('scripts/functions.R')


# Packages
library(data.table)

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


tar_option_set(error = "workspace")

# Targets
list(
	tar_target(paths, get_paths(downpath)),
	tar_target(checked, as.data.table(check_input(paths, downloaded)),
						 pattern = map(paths))
)
