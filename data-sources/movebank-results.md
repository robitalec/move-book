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

    details[, .N, .(is.na(taxon_ids), taxon_ids == '')]

<div class="kable-table">

| is.na | taxon\_ids |    N |
|:------|:-----------|-----:|
| FALSE | FALSE      | 2434 |
| FALSE | TRUE       | 1644 |

</div>
