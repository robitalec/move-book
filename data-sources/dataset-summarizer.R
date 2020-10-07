# === Movement dataset summarizer -----------------------------------------
# Alec Robitaille


# Packages ----------------------------------------------------------------
library(data.table)
library(anytime)


# Input -------------------------------------------------------------------
read_input <- function(path) {

	id <- as.integer(gsub('.csv', '', tstrsplit(path, 'GPS/')[[2]]))
	lines <- readLines(path, 1)

	nodata <- 'No data are available for download'
	http403 <- 'HTTP Status 403 - Incorrect md5 hash'
	internalerror <- 'The server encountered an internal error'

	if(grepl(nodata, lines)) {
		list(id = id, why = nodata)
	} else if (grepl(http403, lines)) {
		list(id = id, why = http403)
	} else if (any(grepl(internalerror, lines))) {
		list(id = id, why = internalerror)
	} else {
		# TODO: check if you can fake read to preview
		DT <- fread(path)

		if (nrow(DT) == 0) {
			list(id = id, why = 'nrow is 0')
		}
	}
}

# Working up from smallest file sizes
# Nrow == 0
p <- '/media/Backup Plus/Movebank/GPS/80475.csv'
p <- '/media/Backup Plus/Movebank/GPS/1233598831.csv'
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
