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
paths = dir(fp, '.csv', full.names = TRUE)[1:10]

plan <- drake_plan(
	checked = target(as.data.table(check_input(paths)), transform = map(file = !!paths)),
	# filtered = filter_check(checked)#,
	read = target(read_input(checked), transform = map(checked))
)
