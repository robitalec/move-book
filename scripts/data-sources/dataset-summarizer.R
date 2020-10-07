# === Movement dataset summarizer -----------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)


# Input -------------------------------------------------------------------
check_input <- function(path, depth = 6) {

	id <- as.integer(gsub('.csv', '', tstrsplit(path, '/')[[depth]]))
	lines <- readLines(path, 1)

	nodata <- 'No data are available for download'
	http403 <- 'HTTP Status 403 - Incorrect md5 hash'
	internalerror <- 'The server encountered an internal error'

	if(grepl(nodata, lines)) {
		list(id = id, path = path, why = nodata)
	} else if (grepl(http403, lines)) {
		list(id = id, path = path, why = http403)
	} else if (any(grepl(internalerror, lines))) {
		list(id = id, path = path, why = internalerror)
	} else {

		# Read just 5 rows, to check if there is data
		DT <- fread(path, nrows = 5)

		if (nrow(DT) == 0) {
			list(id = id, path = path, why = 'nrow is 0')
		} else {
			list(id = id, path = path, why = NA)
		}
	}
}

# Check all available input
# TODO: Switch to flex input from bash/drake
fp <- '/media/Backup Plus/Movebank/Mammalia'
check <- rbindlist(lapply(dir(fp, full.names = TRUE), check_input))


# Prep --------------------------------------------------------------------
read_input <- function(path) {
	DT <- fread(path)

	DT[, ]
}

read_input(check[is.na(why)])

# TODO: set col classes

# TODO: number of individuals
# TODO: number of relocations
# TODO: number of years by individual


# Time (Donuts) -----------------------------------------------------------
# TODO: what are the timezones?
# TODO: time range
# TODO: temporal overlap of individuals



# Space is only time you can see ------------------------------------------
# TODO: is it always lat lon?
# TODO: if so, merge group_pts_latlon ?
# TODO: bbox, area coverage
# TODO: missed fixes, NAs

# Append output -----------------------------------------------------------





# No point rbindlist + freading them all
# TODO: write single input script to
#       taxon, number of individuals, is it actually GPS?
#       drop Argos, number of years, number of locs etc
#       write to summary csv, keep appending
#       bash script Rscript run on all in folder
#       and preserve license terms etc
