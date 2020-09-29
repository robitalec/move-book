Movebank Results
================
Alec Robitaille
2020-09-29

    # Packages ----------------------------------------------------------------
    library(data.table)
    library(taxize)
    library(ggplot2)

    # Data --------------------------------------------------------------------
    details <- fread('data-sources/details.csv')

`taxon_ids` column

    details[is.null(taxon_ids), .N]

    ## [1] 0

    details[is.na(taxon_ids), .N]

    ## [1] 0

    details[taxon_ids == '', .N]

    ## [1] 1644
