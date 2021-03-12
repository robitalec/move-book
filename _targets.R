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
library(ggplot2)
library(sf)
library(mapview)
library(leaflet)

# for missing pipe in rmoveapi (?)
library(magrittr)

# Paths
if (.Platform$OS.type == "windows") {
	path <- file.path('E:', 'ALR_C2')
	downpath <- file.path(path, 'All')
	outpath <- file.path(path, 'Summary')
} else if (.Platform$OS.type == "unix") {
	path <- file.path('/media', 'ICEAGE', 'Movebank')
	downpath <- file.path(path, 'All')
	outpath <- file.path(path, 'Summary', 'All')
	rmdpath <- file.path(path, 'Summary', 'All', 'rmd')
}

# Credentials
service = 'movebank'
username = 'robitalec'
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))
options(rmoveapi.userid = key_list(service)[1, 2])
options(rmoveapi.pass = key_get(service, username))

# Columns to read
cols <- c('tag_local_identifier', 'timestamp', 'deployment_id',
					'tag_id', 'individual_id', 'study_id',
					'sensor_type_id', 'location_long', 'location_lat')


# Ranks for taxize
ranks <- c('family', 'class')


# Targets: options
tar_option_set(#error = "workspace",
							 format = 'qs',
							 memory = 'transient',
							 garbage_collection = TRUE)

# Targets: workflow
list(
	tar_files(paths,
						dir(downpath, '.csv', full.names = TRUE)),

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
						 read_input(merged, ranks = ranks, cols = cols),
						 pattern = map(merged)),

	tar_target(counted_ids,
						 count_ids(read),
						 pattern = map(read)),

	tar_target(temp,
						 temp_overlap(read),
						 pattern = map(read)),

	tar_target(counted_time,
						 count_time(read),
						 pattern = map(read)),

	tar_target(nas,
						 check_nas(read),
						 pattern = map(read)),

	tar_target(bboxes,
						 map_bbox(read, outpath),
						 pattern = map(read)),


	tar_file(rmd, 'scripts/summarizer/summarizer.Rmd'),


	tar_target(
		report,
		change_ext(
			rmarkdown::render(
				rmd,
				params = list(
					countids = counted_ids,
					tempoverlap = temp,
					counttime = counted_time,
					countnas = nas,
					bbox = bboxes,
					details = merged
				),
				output_file = as.character(counted_ids$study_id),
				output_dir = 'chapters',
				clean = TRUE
			),
			inext = 'md',
			outext = 'Rmd'
		),
		pattern = map(counted_ids, temp, counted_time, nas, bboxes, merged),
		format = 'file'
	),

	tar_file(index, 'index.Rmd'),

	tar_file(config, '_bookdown.yml'),

	tar_target(
		book,
		render_with_deps(
			index,
			config,
			deps = report
		),
		format = 'file'
	)

)
