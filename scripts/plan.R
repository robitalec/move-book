# Load drake
library(drake)


# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)
library(ggplot2)
library(mapview)
library(sf)


# Source functions
source('scripts/summarizer/summarizer-functions.R')

# Filepath
fp <- '/media/Backup Plus/Movebank/GPS'



# Plan
plan <- drake_plan(

	# TODO: for later
	# max_expand = 1,

	paths = dir(fp, '.csv', full.names = TRUE)[20:30],

	checked = target(check_input(paths),
									 dynamic = map(paths)),

	read = target(read_input(checked),
								dynamic = map(checked)),

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
# Error: callr subprocess failed: knitr_in() in dynamic targets is illegal. Target: mds

	test = target({print(id_chr());test_grab(id_chr(), read)},
								dynamic = map(read))

	# mds = target(render_md(knitr_in('scripts/summarizer/summarizer.Rmd'),
	# 											 read, counted_ids, counted_time,
	# 											 temp, nas, bboxes),
	# 						 dynamic = map(read, counted_ids, counted_time,
	# 						 							temp, nas, bboxes))
)
