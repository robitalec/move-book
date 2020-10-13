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
fp <- '/media/Backup Plus/Movebank/GPS'
check <- rbindlist(lapply(dir(fp, full.names = TRUE), check_input))


# Prep --------------------------------------------------------------------
read_input <- function(path) {
	rd <- fread(path)

	# TODO: timezone
	rd[, datetime := anytime(timestamp, tz = 'UTC', asUTC = TRUE)]


	# TODO: only GPS data


	# TODO: reduce down to only relevant and common columns
	# TODO: set col classes


}

rd <- read_input(sample(check[is.na(why), path], 1))

# Movebank data structure:
#  http://vocab.nerc.ac.uk/collection/MVB/current/
#  timestamp: UTC time

# Check number of individuals
# TODO: difference between individual, deployment, tag id and individual_local_identifier
idcol <- 'individual_local_identifier'

rd[, uniqueN(individual_id)]
rd[, uniqueN(deployment_id)]
rd[, uniqueN(tag_id)]
rd[, uniqueN(tag_local_identifier)]
rd[, uniqueN(individual_local_identifier)]

# Number of relocations by ID
rd[, .N, by = idcol]


# Check how many rows are NA for each column
lapply(rd, function(x) sum(is.na(x)))


# Time (Donuts) -----------------------------------------------------------
# TODO: temporal overlap of individuals


# Check range of datetime
rd[, range(datetime)]
rd[, range(datetime), by = idcol]
rd[, range(datetime), by = idcol]

# Length of study / diff time
rd[, -1 * Reduce('-', range(datetime))]
rd[, -1 * Reduce('-', range(datetime)), by = idcol]


# Number of years by ID
rd[, uniqueN(year(datetime)), by = idcol]

# Number of repeated months by ID
rd[, uniqueN(year(datetime)), by = .(get(idcol), month(datetime))]




# Space is only time you can see ------------------------------------------
# TODO: is it always lat lon?
# TODO: if so, merge group_pts_latlon ?

# Get bbox
get_bbox <- function(x, y) {
	list(
		minx = min(x, na.rm = TRUE),
		maxx = max(x, na.rm = TRUE),
		miny = min(y, na.rm = TRUE),
		maxy = max(y, na.rm = TRUE)
	)
}

rd[, get_bbox(location_long, location_lat)]


# Output ------------------------------------------------------------------
