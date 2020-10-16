# === Movement dataset summarizer - functions -----------------------------
# Alec Robitaille


# Check input -------------------------------------------------------------
check_input <- function(path, depth = 6) {

	# rbindlist(lapply(dir(path, '.csv', full.names = TRUE), function(p) {

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
	# })
	# )
}

# Read input --------------------------------------------------------------
filter_check <- function(checked) {
	checked[is.na(why)]$path
}


read_input <- function(DT, select = NULL) {
	# TODO: drop this reduce when reading for analysis and not just summary

	if (is.na(DT$why)) {
		rd <- fread(DT$path, select = select)

		rd[, tag_local_identifier := as.character(tag_local_identifier)]

		# Format: yyyy-MM-dd HH:mm:ss.SSS
		# Units: UTC or GPS time
		rd[, datetime := anytime(timestamp, tz = 'UTC', asUTC = TRUE)]
	}
}

# Individuals -------------------------------------------------------------
# Count number of individuals
count_ids <- function(DT) {

	if (!is.null(DT)) {
		DT[, nIndividual := uniqueN(individual_id)]
		DT[, nDeployment := uniqueN(deployment_id)]
		DT[, nTag := uniqueN(tag_id)]

		DT[, sameIndividual := uniqueN(individual_id) == uniqueN(individual_local_identifier)]
		DT[, sameTag := uniqueN(tag_id) == uniqueN(tag_local_identifier)]

		DT[, moreIndividual := uniqueN(individual_id) >= uniqueN(individual_local_identifier)]
		DT[, moreTag := uniqueN(tag_id) >= uniqueN(tag_local_identifier)]

		# Number of relocations by ID
		# TODO: rbindlist this output
		DT[, nLocByIndividual := list(DT[, .N, .(study_id, individual_id)])]

		DT
	} else {
		NULL
	}
}

# Time (Donuts) -----------------------------------------------------------
temp_overlap <- function(DT, type = 'point') {
	DT[, mindatetime := min(datetime), by = individual_id]
	DT[, maxdatetime := max(datetime), by = individual_id]

	if (type == 'point') {
		ggplot(DT, aes(y = as.character(individual_id),
									 yend = as.character(individual_id))) +
			geom_point(aes(x = datetime,
										 group = individual_id),
								 size = 1) +
			guides(color = FALSE) +
			scale_x_datetime(date_labels = '%b %Y') +
			labs(x = 'Date', y = 'ID')
	} else if (type == 'bar') {
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
}


check_time <- function(DT) {
	DT[, lenStudy := -1 * Reduce('-', range(datetime))]
	DT[, nYears := uniqueN(year(datetime))]
	DT[, nMonth := uniqueN(year(datetime)), by = month(datetime)]

	setorder(DT, datetime)
	DT[, fixRate := difftime(datetime, shift(datetime), units = 'hours'), by = individual_id]
}


# Get bbox
get_bbox <- function(x, y) {
	st_as_sf(st_as_sfc(st_bbox(c(
		xmin = min(x, na.rm = TRUE),
		xmax = max(x, na.rm = TRUE),
		ymin = min(y, na.rm = TRUE),
		ymax = max(y, na.rm = TRUE)
	))), crs = 4326)
}
