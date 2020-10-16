# Load drake
library(drake)


# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)
library(ggplot2)
library(mapview)

# Source functions
source('scripts/summarizer/summarizer-functions.R')

# Plan
fp <- '/media/Backup Plus/Movebank/GPS'

sub <- 20:30
paths <- dir(fp, '.csv', full.names = TRUE)[sub]
names(paths) <- dir(fp, '.csv')[sub]

plan <- drake_plan(
	checked = target(check_input(file_in(file)),
									 transform = map(file = !!paths)),
	read = target(read_input(checked),
								transform = map(checked)),
	counted = target(count_ids(read),
									 transform = map(read))
)
