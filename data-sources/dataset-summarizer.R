# === Movement dataset summarizer -----------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)


# Input -------------------------------------------------------------------
# TODO: flex input

read_input <- function(path) {

	id <- as.integer(gsub('.csv', '', tstrsplit(path, 'GPS/')[[2]]))
	lines <- readLines(path, 1)

	if(grepl('No data are available for download', lines)) {
		list(id = id, dataAvailable = FALSE)
	}
}

p<- '/media/Backup Plus/Movebank/GPS/80475.csv'

read_input(p)


# Prep --------------------------------------------------------------------



# Time (Donuts) -----------------------------------------------------------



# Space is only time you can see ------------------------------------------




# Append output -----------------------------------------------------------





# No point rbindlist + freading them all
# TODO: write single input script to
#       taxon, number of individuals, is it actually GPS?
#       drop Argos, number of years, number of locs etc
#       write to summary csv, keep appending
#       bash script Rscript run on all in folder
#       and preserve license terms etc
