# === Movebank summarizer - functions -----------------------------
# Alec Robitaille





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

# Read input --------------------------------------------------------------
read_input <- function(DT, select = NULL) {
	rd <- fread(DT$path, select = select)

	rd[, tag_local_identifier := as.character(tag_local_identifier)]

	# Format: yyyy-MM-dd HH:mm:ss.SSS
	# Units: UTC or GPS time
	rd[, datetime := anytime(timestamp, tz = 'UTC', asUTC = TRUE)]

	rd
}



# Resolve taxon -----------------------------------------------------------
resolve_taxon <- function(DT) {

}



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
	# DT[, nLocByIndividual := list(DT[, .N, .(study_id, individual_id)])]

	cols <- c('study_id', 'sensor_type_id',
						'nIndividual', 'nDeployment', 'nTag',
						'sameIndividual', 'sameTag', 'moreIndividual',
						'moreTag')

	unique(DT[, .SD, .SDcols = cols], by = 'study_id')
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

check_nas <- function(DT) {
	# Check how many rows are NA for each column
	lapply(DT, function(x) sum(is.na(x)) / length(x))
}


count_time <- function(DT) {
	DT[, lenStudy := -1 * Reduce('-', range(datetime))]
	DT[, nYears := uniqueN(year(datetime))]
	# DT[, nMonth := uniqueN(year(datetime)), by = month(datetime)]

	setorder(DT, datetime)
	DT[, fixRate := difftime(datetime, shift(datetime), units = 'hours'), by = individual_id]
	# DT[, fixRateSummary := list(summary(as.numeric(fixRate)))]

	cols <- c('study_id', 'sensor_type_id',
						'lenStudy', 'nYears')#, 'fixRateSummary')

	unique(DT[, .SD, .SDcols = cols], by = 'study_id')
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

map_bbox <- function(DT, path) {
	boxes <- DT[, .(box = list(get_bbox(location_long, location_lat))),
							by = individual_id]

	study <- DT$study_id[[1]]
	m <- mapview(boxes$box, legend = FALSE)@map %>%
		addMiniMap(position = 'bottomleft',
							 zoomLevelFixed = 2)

	outpath <- paste0(path, 'figures/bbox-', study, '.png')
	mapshot(m, file = outpath)
	outpath
}


build_rmds <- function(template, id, DT, path) {
	study <- DT$study_id[[1]]
	id <- gsub('rmds_', '', id)

	outpath <- paste0(path, 'rmd/', study, '.Rmd')
	file.copy(template, outpath, overwrite = TRUE)

	lines <- readLines(outpath)
	lns <- gsub('KEY', id, lines)
	lns <- gsub('Title', study, lns)

	writeLines(lns, outpath)
	outpath
}

render_with_deps <- function(index, config, deps) {
	bookdown::render_book(input = index, config_file = config, quiet = TRUE)
}




