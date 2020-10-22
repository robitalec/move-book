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


# Credentials
service = 'movebank'
username = 'robitalec'
login <- movebankLogin(key_list(service)[1, 2], key_get(service, username))


# Source functions
source('scripts/summarizer/summarizer-functions.R')

# Paths
fp <- '/media/ICEAGE/Movebank/GPS/'
outpath <- '/media/ICEAGE/Movebank/Summary/GPS/'

paths <- dir(fp, '.csv', full.names = TRUE)[20:30]

# Bookdown option
options(bookdown.render.file_scope = FALSE)


# Plan
plan <- drake_plan(
	details = get_details(login),

	taxed = resolve_taxon(details),

	checked = target(as.data.table(check_input(paths)),
									 dynamic = map(paths)),

	filtered = target(checked[is.na(why)]),

	read = target(read_input(filtered),
								dynamic = map(filtered)),

	taxed = target(resolve_taxon(read),
								 dynamic = map(read)),

	counted_ids = target(count_ids(taxed),
											 dynamic = map(taxed)),

	temp = target(temp_overlap(taxed),
								dynamic = map(taxed)),

	counted_time = target(count_time(taxed),
												dynamic = map(taxed)),

	nas = target(check_nas(taxed),
							 dynamic = map(taxed)),

	bboxes = target(map_bbox(taxed, outpath),
									dynamic = map(taxed), format = 'file'),

	rmds = target(build_rmds(file_in('scripts/summarizer/summarizer.Rmd'),
													 id_chr(), taxed, outpath),
								dynamic = map(taxed), format = 'file'),

	rendered = render_with_deps(index = knitr_in('index.Rmd'),
															config = file_in('_bookdown.yml'),
															deps = list(taxed, counted_ids, counted_time,
																					temp, nas, bboxes, rmds))
)
