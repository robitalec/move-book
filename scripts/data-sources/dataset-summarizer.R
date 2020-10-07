# === Movement dataset summarizer -----------------------------------------
# Alec Robitaille


# ***************
# TODO: check all metadata for fields in movebank database
# ***************



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

	DT[, datetime := anytime(timestamp)]
	# TODO: only GPS data



}

rd <- read_input(check[is.na(why), path][sample(1:50, 1)])

# Check number of individuals
# TODO: difference between individual, deployment, tag id and individual_local_identifier
idcol <- 'individual_local_identifier'

rd[, uniqueN(individual_id)]
rd[, uniqueN(deployment_id)]
rd[, uniqueN(tag_id)]
rd[, uniqueN(tag_local_identifier)]
rd[, uniqueN(individual_local_identifier)]

# Check range of datetime
rd[, range(datetime)]
rd[, range(datetime), by = individual_id]
rd[, range(datetime), by = individual_local_identifier]

# Length of study / diff time
rd[, -1 * Reduce('-', range(datetime))]
rd[, -1 * Reduce('-', range(datetime)), individual_local_identifier]

# Check how many rows are NA for each column
lapply(rd, function(x) sum(is.na(x)))



# TODO: reduce down to only relevant and common columns
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
