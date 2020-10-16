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
sub <- 20:30


# Plan
plan <- drake_plan(
	paths = dir(fp, '.csv', full.names = TRUE)[sub],

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
									dynamic = map(read))
)
