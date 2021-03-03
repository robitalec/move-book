# === Movement dataset summarizer - functions -----------------------------
# Alec Robitaille


# Get details -------------------------------------------------------------
try_get <- function(study, login = login) {
	tryCatch(expr = getMovebankStudy(study, login = login),
					 error = function(cond) return(list(error = as.character(cond))),
					 warning = function(cond) return(list(warning = as.character(cond))))
}

get_details <- function(id) {
	studies <- getStudy(id)
	setDT(studies)
	studies[, timestamp_first_deployed_location := anytime(timestamp_first_deployed_location)]
	studies[, timestamp_last_deployed_location := anytime(timestamp_last_deployed_location)]
	# rbindlist(lapply(studies, try_get, login = login),
	# 					fill = TRUE, use.names = TRUE)

}


# Download studies --------------------------------------------------------
download_studies <- function(details, outpath) {
	details[, tryCatch(
		getEvent(
			studyid = .BY[[1]],
			attributes = 'all',
			save_as = file.path(outpath, paste0(.BY[[1]], '.csv')),
			accept_license = TRUE
		),
		error = function(e) NULL
	), by = id]
}


# Get paths ---------------------------------------------------------------
get_paths <- function(path, ...) dir(path, '.csv', full.names = TRUE)



# Resolve taxon -----------------------------------------------------------
# Resolve the taxon_ids column with taxize
# Sort each resolved taxon_id (splitting lists) by score, preserving the top
sort_resolved <- function(tax) {
	data.table(gnr_resolve(tax))[, .SD[order(score)][1], user_supplied_name]
}

classify_taxon <- function(id, ranks) {
	z <- data.table(classification(id, db = 'ncbi', ask = FALSE,
																 messages = FALSE)[[1]])
	if (all(is.na(z)) || z[rank %in% ranks, .N == 0]) {
		data.table(t(setNames(rep(NA_character_, length(ranks)), ranks)))
	} else {
		zz <- t(z[rank %in% ranks])
		zzz <- data.table(zz)[1]
		colnames(zzz) <- zz[2,]

		if (any(!ranks %in% colnames(zzz))) {
			zzz[, (setdiff(ranks, colnames(zzz))) := NA_character_]
		}
		zzz
	}
}

resolve_taxon <- function(details, subid, ranks = c('family', 'class')) {
	# Drop where taxon_ids is ''
	subdet <- details[taxon_ids != '' & id %in% subid]

	# Apply over each (potential) list within taxon_ids row, sorting resolved
	taxes <- subdet[, rbindlist(lapply(strsplit(taxon_ids, ','), sort_resolved),
															fill = TRUE, use.names = TRUE),
									by = .(id, taxon_ids)]

	taxes[, (ranks) := classify_taxon(matched_name, ranks)[, .SD, .SDcols = ranks],
				matched_name]

}

# Check input -------------------------------------------------------------
check_input <- function(path, ...) {

	id <- as.integer(gsub('.csv', '', basename(path)))

	lines <- readLines(path, 1)

	nodata <- 'No data are available for download'
	hash <- 'HTTP Status 403 - Incorrect md5 hash'
	forbid <- 'HTTP Status 403 – Forbidden'
	internalerror <- 'The server encountered an internal error'
	http500 <- 'HTTP Status 500'

	if(grepl(nodata, lines)) {
		data.table(id = id, path = path, why = nodata, cols = NA)
	} else if (grepl(hash, lines)) {
		data.table(id = id, path = path, why = hash, cols = NA)
	} else if (grepl(forbid, lines)) {
		data.table(id = id, path = path, why = forbid, cols = NA)
	} else if (any(grepl(internalerror, lines))) {
		data.table(id = id, path = path, why = internalerror, cols = NA)
	} else if (any(grepl(http500, lines))) {
		data.table(id = id, path = path, why = http500, cols = NA)
	} else {

		# Read just 5 rows, to check if there is data
		# DT <- fread(path, nrows = 5)

		# For now, while issue is open. Careful about temp dir
		DT <- fread(cmd = paste('head -n 5', path))

		if (nrow(DT) == 0) {
			data.table(id = id, path = path, why = 'nrow is 0', cols = NA)
		} else {
			data.table(id = id, path = path, why = NA, cols = list(colnames(DT)))
		}
	}
}

# Read input --------------------------------------------------------------
read_input <- function(DT, ranks, cols) {
	rd <- fread(DT$path, select = cols)

	rd[, tag_local_identifier := as.character(tag_local_identifier)]

	# Format: yyyy-MM-dd HH:mm:ss.SSS
	# Units: UTC or GPS time
	rd[, datetime := anytime(timestamp, tz = 'UTC', asUTC = TRUE)]

	taxnames <- c('matched_name', ranks)
	rd[, (taxnames) := DT[, .SD, .SDcols = taxnames]]
}


# Individuals -------------------------------------------------------------
# Count number of individuals
count_ids <- function(DT) {
	DT[, nIndividual := uniqueN(individual_id)]
	DT[, nDeployment := uniqueN(deployment_id)]
	DT[, nTag := uniqueN(tag_id)]

	DT[, nRows := .N]

	DT[, sameIndividual := uniqueN(individual_id) == uniqueN(individual_local_identifier)]
	DT[, sameTag := uniqueN(tag_id) == uniqueN(tag_local_identifier)]

	DT[, moreIndividual := uniqueN(individual_id) >= uniqueN(individual_local_identifier)]
	DT[, moreTag := uniqueN(tag_id) >= uniqueN(tag_local_identifier)]

	# Number of relocations by ID
	# TODO: rbindlist this output?
	# DT[, nLocByIndividual := list(DT[, .N, .(study_id, individual_id)])]

	unique(DT, by = 'study_id')
}

# Time (Donuts) -----------------------------------------------------------
temp_overlap <- function(DT, type = 'daily') {
	DT[, mindatetime := min(datetime), by = individual_id]
	DT[, maxdatetime := max(datetime), by = individual_id]
	DT[, Date := as.IDate(datetime)]

	DT[, individual_id := as.character(individual_id)]
	if (type == 'point') {
		ggplot(DT, aes(y = individual_id)) +
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
	} else if (type == 'daily') {
		ggplot(unique(DT, by = c('individual_id', 'Date'))) +
			geom_point(aes(x = datetime,
			               y = individual_id),
			               size = 1) +
			guides(color = FALSE) +
			scale_x_datetime(date_labels = '%F') +
			labs(x = 'Date', y = 'ID')
	}
}

check_nas <- function(DT) {
	# Check how many rows are NA for each column
	as.data.table(lapply(DT, function(x) sum(is.na(x)) / length(x)))
}


count_time <- function(DT) {
	DT[, lenStudy := -1 * Reduce('-', range(datetime))]
	DT[, nYears := uniqueN(year(datetime))]
	# DT[, nMonth := uniqueN(year(datetime)), by = month(datetime)]

	setorder(DT, datetime)
	DT[, fixRate := difftime(datetime, data.table::shift(datetime),
													 units = 'hours'),
		 by = individual_id]
	# DT[, fixRateSummary := list(summary(as.numeric(fixRate)))]

	cols <- c('study_id', 'sensor_type_id',
						'lenStudy', 'nYears')#, 'fixRateSummary')

	unique(DT, by = 'study_id')
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

	outpath <- file.path(path, 'figures', paste0('bbox-', study, '.png'))
	mapshot(m, file = outpath)
	outpath
}



# RMarkdown ---------------------------------------------------------------
change_ext <- function(file, inext, outext) {
	newfile <- gsub(inext, outext, file)
	file.rename(file, newfile)
	newfile
}




build_rmds <- function(template, id, DT, path) {
	if(!dir.exists(file.path(path, 'rmd'))) dir.create(file.path(path, 'rmd'))
	study <- DT$study_id[[1]]
	id <- gsub('rmds_', '', id)

	outpath <- file.path(path, 'rmd', paste0(study, '.Rmd'))
	file.copy(template, outpath, overwrite = TRUE)

	lines <- readLines(outpath)
	lns <- gsub('KEY', id, lines)
	lns <- gsub('Title', study, lns)

	writeLines(lns, outpath)
	outpath
}

render_with_deps <- function(index, config, deps) {
	bookdown::render_book(input = index, config_file = config)
}




