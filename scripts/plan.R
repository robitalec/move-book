# Load drake
library(drake)


# Packages
library(data.table)
library(anytime)
library(ggplot2)
library(mapview)
library(sf)


# Source functions
source('scripts/summarizer/summarizer-functions.R')

# Paths
fp <- '/media/Backup Plus/Movebank/GPS'
paths <- dir(fp, '.csv', full.names = TRUE)[20:30]


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

	bboxes = target(map_bbox(read),
									dynamic = map(read)),

	rmds = target(build_rmds(id_chr(), read),
								dynamic = map(read)),

	move_index = file.copy('scripts/summarizer/index.Rmd',
												 paste0(fp, 'rmd/index.Rmd'),
												 overwrite = TRUE),

	rendered = render_rmds(knitr_in(paste0(fp, 'rmd/index.Rmd')),
												 knitr_in(rmds))

	# TODO: fix dependency on rmd

	# mds = target(render_md(knitr_in('scripts/summarizer/summarizer.Rmd'),
	# 											 read, counted_ids, counted_time,
	# 											 temp, nas, bboxes),
	# 						 dynamic = map(read, counted_ids, counted_time,
	# 						 							temp, nas, bboxes))
)
