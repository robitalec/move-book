# Load drake
library(drake)


# Packages
library(data.table)
library(anytime)
library(ggplot2)
library(mapview)
library(sf)
library(patchwork)
library(leaflet)
library(keyring)
library(move)
library(taxize)
library(rmoveapi)

# Credentials
service = 'movebank'
username = 'robitalec'
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))
options(rmoveapi.userid = key_list(service)[1, 2])
options(rmoveapi.pass = key_get(service, username))


# Source functions
source('scripts/functions.R')

# Paths
if (.Platform$OS.type == "windows") {
		# TODO: add windows path

} else if (.Platform$OS.type == "unix") {
	fp <- '/media/ICEAGE/Movebank/All'
	outpath <- '/media/ICEAGE/Movebank/Summary/All/'
}


ranks <- c('family', 'class')

# Options
options(bookdown.render.file_scope = FALSE)
taxize_options(TRUE)


# Plan
plan <- drake_plan(
	details = get_details(login),

	downloaded = download_studies(details, outpath = fp),

	paths = get_paths(fp, downloaded),

	checked = target(as.data.table(check_input(paths, downloaded)),
									 dynamic = map(paths)),

	filtered = target(checked[is.na(why)]),

	taxed = resolve_taxon(details, filtered$id, ranks),

	merged = merge(filtered, taxed, by = 'id'),

	read = target(read_input(merged, ranks = ranks),
								dynamic = map(merged)),

	counted_ids = target(count_ids(read),
											 dynamic = map(read)),

	temp = target(temp_overlap(read),
								dynamic = map(read)),

	counted_time = target(count_time(read),
												dynamic = map(read)),

	nas = target(check_nas(read),
							 dynamic = map(read)),

	bboxes = target(map_bbox(read, outpath),
									dynamic = map(read), format = 'file'),

	rmds = target(build_rmds(file_in('scripts/summarizer/summarizer.Rmd'),
													 id_chr(), read, outpath),
								dynamic = map(read), format = 'file'),

	rendered = render_with_deps(index = knitr_in('index.Rmd'),
															config = file_in('_bookdown.yml'),
															deps = list(counted_ids, counted_time,
																					temp, nas, bboxes, rmds))
)
