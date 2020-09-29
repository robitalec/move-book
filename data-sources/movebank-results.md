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
    taxes <- fread('data-sources/taxes.csv')
    DT <- fread('data-sources/taxed-details.csv')

`taxon_ids` column

    details[, .N, .(is.na(taxon_ids), taxon_ids == '')]

<div class="kable-table">

| is.na | taxon\_ids |    N |
|:------|:-----------|-----:|
| FALSE | FALSE      | 2434 |
| FALSE | TRUE       | 1644 |

</div>

Out of 1644 rows with seemingly valid `taxon_ids`, there are up to 17
species listed in any row. Eg.

    details[id == 422952928]$taxon_ids

    ## [1] "Anser albifrons,Chen caerulescens,Chen rossii,Anas platyrhynchos,Anas strepera,Anas acuta,Anas crecca,Anas discors,Anas cyanoptera,Anas americana,Anas clypeata,Aythya valisineria,Aythya marila,Circus cyaneus,Phasianus colchicus"

Grabbing the family and class, then combining the taxonomies with the
study details dataset, we have 4784 species by study rows.
