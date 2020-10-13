# === Movement dataset summarizer -----------------------------------------
# Alec Robitaille


# ***************
# TODO: check all metadata for fields in movebank database
# ***************



# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)
library(ggplot2)


# Data structure ----------------------------------------------------------
## Movebank data structure: http://vocab.nerc.ac.uk/collection/MVB/current/
# timestamp: Format: yyyy-MM-dd HH:mm:ss.SSS Units: UTC or GPS time
# location lat/long: decimal degrees, WGS84
# heading: degrees clockwise from north
# ground speed: m/s
# GPS fix type: 1 no fix, 2 2D, 3 3D fix (altitude)
# UTM easting, northing: WGS84 reference system
# UTM zone: potentially selected automatically based off the locations
# IDs: "an internal movebank id is *sometimes* shown"



# Check input -------------------------------------------------------------
check_input <- function(path, depth = 6) {

	id <- as.integer(gsub('.csv', '', tstrsplit(path, '/')[[depth]]))
	lines <- readLines(path, 1)

	nodata <- 'No data are available for download'
	http403 <- 'HTTP Status 403 - Incorrect md5 hash'
	internalerror <- 'The server encountered an internal error'

	if(grepl(nodata, lines)) {
		list(id = id, path = path, why = nodata, cols = NA)
	} else if (grepl(http403, lines)) {
		list(id = id, path = path, why = http403, cols = NA)
	} else if (any(grepl(internalerror, lines))) {
		list(id = id, path = path, why = internalerror, cols = NA)
	} else {

		# Read just 5 rows, to check if there is data
		DT <- fread(path, nrows = 5)

		if (nrow(DT) == 0) {
			list(id = id, path = path, why = 'nrow is 0', cols = NA)
		} else {
			list(id = id, path = path, why = NA, cols = list(colnames(DT)))
		}
	}
}

# Check all available input
# TODO: Switch to flex input from bash/drake
fp <- '/media/Backup Plus/Movebank/GPS'
check <- rbindlist(lapply(dir(fp, full.names = TRUE), check_input))


# Check all column names
# all unique colnames
Reduce(union, check[!is.na(cols)]$cols)

# only colnames common across all
commoncols <- Reduce(intersect, check[!is.na(cols)]$cols)

# check how many datasets have necessary columns
check[, .N, grepl('long', cols)]
check[, .N, grepl('lat', cols)]



# Read input --------------------------------------------------------------
read_input <- function(path, select = NULL) {
	# TODO: drop this reduce when reading for analysis and not just summary
	rd <- fread(path, select = select)

	# Format: yyyy-MM-dd HH:mm:ss.SSS
	# Units: UTC or GPS time
	rd[, datetime := anytime(timestamp, tz = 'UTC', asUTC = TRUE)]
}
rd <- read_input(sample(check[is.na(why), path], 1))



# Individuals -------------------------------------------------------------
# Count number of individuals
count_ids <- function(DT) {
	DT[, nIndividual := uniqueN(individual_id)]
	DT[, nDeployment := uniqueN(deployment_id)]
	DT[, nTag := uniqueN(tag_id)]

	DT[, sameIndividual := uniqueN(individual_id) == uniqueN(individual_local_identifier)]
	DT[, sameTag := uniqueN(tag_id) == uniqueN(tag_local_identifier)]

	DT[, moreIndividual := uniqueN(individual_id) >= uniqueN(individual_local_identifier)]
	DT[, moreTag := uniqueN(tag_id) >= uniqueN(tag_local_identifier)]

	# Number of relocations by ID
	# TODO: rbindlist this output
	DT[, nLocByIndividual := list(rd[, .N, .(study_id, individual_id)])]

	DT
}

count_ids(rd)

# Are there more tags/individuals listed in the non-local columns?
rd[, unique(moreTag)]
rd[, unique(moreIndividual)]



# Check NAs ---------------------------------------------------------------
# Check how many rows are NA for each column
rd[, nrowNA := list(lapply(rd, function(x) sum(is.na(x))))]


# Time (Donuts) -----------------------------------------------------------
temp_overlap <- function(DT) {
	DT[, mindatetime := min(datetime), by = individual_id]
	DT[, maxdatetime := max(datetime), by = individual_id]

	ggplot(DT, aes(y = as.character(individual_id),
								 yend = as.character(individual_id))) +
		geom_segment(aes(x = mindatetime,
										 xend = maxdatetime,
										 group = individual_id),
								 size = 4) +
		guides(color = FALSE) +
		scale_x_datetime(date_labels = '%b %Y') +
		labs(x = 'Date', y = 'ID')
}
temp_overlap(rd)

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
