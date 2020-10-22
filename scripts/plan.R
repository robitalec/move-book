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
# options(bookdown.preview.cutoff = 100)


# Plan
plan <- drake_plan(
	checked = target(as.data.table(check_input(paths)),
									 dynamic = map(paths)),

	filtered = target(checked[is.na(why)]),

	read = target(read_input(filtered),
								dynamic = map(filtered)),

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
															deps = list(read, counted_ids, counted_time,
																					temp, nas, bboxes, rmds))
)
