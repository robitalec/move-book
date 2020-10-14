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


plan <- drake_plan(
  checked = check_input(fp),

)
