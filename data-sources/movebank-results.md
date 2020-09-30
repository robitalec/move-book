Movebank Results
================
Alec Robitaille
2020-09-30

    # Packages ----------------------------------------------------------------
    library(data.table)
    library(taxize)
    library(ggplot2)
    library(patchwork)

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

TODO: N access, family, class, access by taxonomy etc

    DT[, .N, class]

<div class="kable-table">

| class          |    N |
|:---------------|-----:|
|                | 1704 |
| Aves           | 2180 |
| Mammalia       |  744 |
| Insecta        |    2 |
| Chondrostei    |    1 |
| Reptilia       |  106 |
| Amphibia       |    2 |
| Teleostei      |   10 |
| Chondrichthyes |   35 |

</div>

    ggplot(DT) + 
        geom_bar(aes(class, fill = i_have_download_access)) +
        guides(fill = FALSE)

![](movebank-results_files/figure-gfm/class-1.png)<!-- -->

Careful double counting, because the `DT` dataset now has duplicated
study rows for each parsed taxon.

    # Grab the unique rows based on study id
    countDT <- unique(DT, by = 'id')

*Mammalia*
==========

Just exploring mammals, the following figures show download access TRUE
in blue, and FALSE in red.

Number of studies by family
---------------------------

    ggplot(countDT[class == 'Mammalia']) + 
        geom_bar(aes(factor(family, sort(unique(family), TRUE)),
                                 fill = i_have_download_access)) +
        coord_flip() +
        labs(y = 'Number of studies', x = 'Family') +
        guides(fill = FALSE)

![](movebank-results_files/figure-gfm/studies-1.png)<!-- -->

Number of individuals by family
-------------------------------

    ggplot(countDT[class == 'Mammalia', sum(number_of_individuals), .(i_have_download_access, family)]) + 
        geom_col(aes(factor(family, sort(unique(family), TRUE)),
                                 V1,
                                 fill = i_have_download_access)) +
        coord_flip() +
        labs(y = 'Number of individuals', x = 'Family')  +
        guides(fill = FALSE)

![](movebank-results_files/figure-gfm/numbids-1.png)<!-- -->

Number of relocations by family
-------------------------------

    ggplot(countDT[class == 'Mammalia', sum(number_of_deployed_locations), .(i_have_download_access, family)]) + 
        geom_col(aes(factor(family, sort(unique(family), TRUE)),
                                 V1,
                                 fill = i_have_download_access)) +
        coord_flip() +
        labs(y = 'Number of relocations', x = 'Family') +
        guides(fill = FALSE)

    ## Warning: Removed 18 rows containing missing values (position_stack).

![](movebank-results_files/figure-gfm/numblobs-1.png)<!-- -->

    DT[family == 'Procyonidae']

<div class="kable-table">

| taxon\_ids                                                                                                                                                                           | acknowledgements | citation                                                                                                                                                                                                                                                                                                                                                                                                                                                           | create\_ts              |                                event\_grace\_period | go\_public\_date | go\_public\_license\_type | grants\_used                                                                                                       | has\_quota | i\_am\_owner |         id | is\_test | license\_terms                                                                                                       | license\_type | main\_location\_lat | main\_location\_long | name                                                              | number\_of\_deployments | number\_of\_individuals | number\_of\_tags | principal\_investigator\_address | principal\_investigator\_email                                   | principal\_investigator\_name | study\_objective                                                                                                                      | study\_type | suspend\_go\_public\_date | suspend\_license\_terms | i\_can\_see\_data | there\_are\_data\_which\_i\_cannot\_see | i\_have\_download\_access | i\_am\_collaborator | study\_permission | timestamp\_first\_deployed\_location | timestamp\_last\_deployed\_location | number\_of\_deployed\_locations | sensor\_type\_ids | error | user\_supplied\_name | submitted\_name     | matched\_name       | data\_source\_title | score | family      | class    |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------|----------------------------------------------------:|:-----------------|:--------------------------|:-------------------------------------------------------------------------------------------------------------------|:-----------|:-------------|-----------:|:---------|:---------------------------------------------------------------------------------------------------------------------|:--------------|--------------------:|---------------------:|:------------------------------------------------------------------|------------------------:|------------------------:|-----------------:|:---------------------------------|:-----------------------------------------------------------------|:------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------|:------------|:--------------------------|:------------------------|:------------------|:----------------------------------------|:--------------------------|:--------------------|:------------------|:-------------------------------------|:------------------------------------|--------------------------------:|:------------------|:------|:---------------------|:--------------------|:--------------------|:--------------------|------:|:------------|:---------|
| Bassaricyon neblina                                                                                                                                                                  |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2018-02-12 22:42:49.514 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        |  419363180 | FALSE    |                                                                                                                      | CUSTOM        |             -0.0175 |               -78.68 | Olinguitos of Bellavista                                          |                       2 |                       2 |                2 |                                  |                                                                  |                               | GPS tracking olinguitos                                                                                                               | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2018-01-16 08:02:04.000              | 2018-02-19 15:00:12.000             |                            1458 | GPS               |       | Bassaricyon neblina  | Bassaricyon neblina | Bassaricyon neblina | NCBI                | 0.988 | Procyonidae | Mammalia |
| Didelphis virginiana,Procyon lotor                                                                                                                                                   |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2013-09-04 16:31:31.975 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        |   11948467 | FALSE    | Data may be used for any noncommercial product without extra permission. Please just let us know what you have done. | CUSTOM        |             35.7804 |               -78.67 | NCSU Mammalogy Campus Carnivores                                  |                       3 |                       3 |                4 |                                  |                                                                  |                               | A study of carnivores on the NC State University Campus conducted by NCSU Mammalogy students                                          | research    | NA                        | TRUE                    | TRUE              | FALSE                                   | TRUE                      | FALSE               | na                | 2013-09-04 00:00:55.001              | 2013-10-23 10:15:22.001             |                            2912 | GPS,Acceleration  |       | Procyon lotor        | Procyon lotor       | Procyon lotor       | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica                                                                                                                                                                         |                  | Powell RA, Ellwood S, Kays R, Maran T (2017) Stink or swim: techniques to meet the challenges for the study and conservation of small critters that hide, swim, or climb, and may otherwise make themselves unpleasant. In Macdonald DW, Newman C, Harrington LA, eds, Biology and Conservation of Musteloids. Oxford University Press, Oxford. p 216–230. <a href="doi:10.1093/oso/9780198759805.003.0008" class="uri">doi:10.1093/oso/9780198759805.003.0008</a> | 2011-04-19 16:51:41.403 |                                                   0 |                  |                           | National Geographic, STRI                                                                                          | TRUE       | FALSE        |    2950149 | FALSE    | These data have been published by the Movebank Data Repository with DOI                                              |               |                     |                      |                                                                   |                         |                         |                  |                                  |                                                                  |                               |                                                                                                                                       |             |                           |                         |                   |                                         |                           |                     |                   |                                      |                                     |                                 |                   |       |                      |                     |                     |                     |       |             |          |
| &lt;a href="""“<a href="http://dx.doi.org/10.5441/001/1.41076dq1" class="uri">http://dx.doi.org/10.5441/001/1.41076dq1</a>”""" target=""""\_blank""""&gt;10.5441/001/1.41076dq1</a>. | CUSTOM           | 9.1668                                                                                                                                                                                                                                                                                                                                                                                                                                                             | -79.84                  | Coatis on BCI Panama (data from Powell et al. 2017) | 2                | 2                         | 2                                                                                                                  |            |              |            |          | research                                                                                                             | NA            |               FALSE |                 TRUE | FALSE                                                             |                    TRUE |                   FALSE |               na | 2010-03-15 16:31:52.001          | 2010-04-24 13:46:39.999                                          | 1201                          | GPS,Acceleration                                                                                                                      |             | Nasua narica              | Nasua narica            | Nasua narica      | NCBI                                    | 0.988                     | Procyonidae         | Mammalia          |                                      |                                     |                                 |                   |       |                      |                     |                     |                     |       |             |          |
| Nasua narica                                                                                                                                                                         |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2020-02-23 20:19:21.607 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        | 1080117799 | FALSE    |                                                                                                                      | CUSTOM        |              9.1620 |               -79.85 | Smarties                                                          |                       2 |                       2 |                5 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2020-02-21 10:59:23.000              | 2020-03-09 23:00:55.000             |                          521045 | GPS,Acceleration  |       | Nasua narica         | Nasua narica        | Nasua narica        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2018-04-23 19:11:08.758 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        |  466459623 | FALSE    |                                                                                                                      | CUSTOM        |              9.1560 |               -79.85 | FFT 2017-2018 post-Rasmusgeddon - GPS only                        |                      54 |                      56 |               60 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2017-12-01 10:53:41.000              | 2018-04-19 00:00:29.000             |                         2249310 | GPS               |       | Nasua narica         | Nasua narica        | Nasua narica        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2018-04-23 19:11:08.758 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        |  466459623 | FALSE    |                                                                                                                      | CUSTOM        |              9.1560 |               -79.85 | FFT 2017-2018 post-Rasmusgeddon - GPS only                        |                      54 |                      56 |               60 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2017-12-01 10:53:41.000              | 2018-04-19 00:00:29.000             |                         2249310 | GPS               |       | Potos flavus         | Potos flavus        | Potos flavus        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2020-04-14 13:48:56.587 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        | 1120749252 | FALSE    |                                                                                                                      | CUSTOM        |              9.1640 |               -79.84 | Food for Thought - Comparative Frugivore Tracking Cleaned data v2 |                      48 |                      49 |               43 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2015-12-11 10:54:00.000              | 2018-06-14 13:00:00.000             |                          660989 | GPS               |       | Nasua narica         | Nasua narica        | Nasua narica        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2020-04-14 13:48:56.587 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        | 1120749252 | FALSE    |                                                                                                                      | CUSTOM        |              9.1640 |               -79.84 | Food for Thought - Comparative Frugivore Tracking Cleaned data v2 |                      48 |                      49 |               43 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2015-12-11 10:54:00.000              | 2018-06-14 13:00:00.000             |                          660989 | GPS               |       | Potos flavus         | Potos flavus        | Potos flavus        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2020-04-14 12:22:09.145 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        | 1120686220 | FALSE    |                                                                                                                      | CUSTOM        |              9.1618 |               -79.84 | Food for Thought - Comparative Frugivore Tracking v5 raw data     |                      49 |                      50 |               43 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2015-12-11 10:54:53.000              | 2018-05-31 17:00:26.000             |                         4014951 | GPS               |       | Nasua narica         | Nasua narica        | Nasua narica        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua narica,Pecari tajacu,Ateles geoffroyi,Cebus capucinus,Potos flavus                                                                                                             |                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 2020-04-14 12:22:09.145 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        | 1120686220 | FALSE    |                                                                                                                      | CUSTOM        |              9.1618 |               -79.84 | Food for Thought - Comparative Frugivore Tracking v5 raw data     |                      49 |                      50 |               43 |                                  |                                                                  |                               |                                                                                                                                       | research    | NA                        | FALSE                   | FALSE             | TRUE                                    | FALSE                     | FALSE               | na                | 2015-12-11 10:54:53.000              | 2018-05-31 17:00:26.000             |                         4014951 | GPS               |       | Potos flavus         | Potos flavus        | Potos flavus        | NCBI                | 0.988 | Procyonidae | Mammalia |
| Nasua nasua                                                                                                                                                                          |                  | Within-group spatial position in ring-tailed coatis (Nasua nasua): Balancing predation, feeding success, and social competition by Hirsch, Benjamin Thomas, PhD, STATE UNIVERSITY OF NEW YORK AT STONY BROOK, 2007                                                                                                                                                                                                                                                 | 2009-07-16 17:00:34.844 |                                                   0 |                  |                           |                                                                                                                    | TRUE       | FALSE        |     433318 | FALSE    | Do not use for any purpose without contacting Ben Hirsch to discuss collaboration.                                   | CUSTOM        |            -25.6863 |               -54.45 | South American Coati, Nasua nasua, Argentina, Hirsch Ph.D. work   |                       1 |                       1 |                1 | Smithsonian                      | <a href="mailto:hirschb@si.edu" class="email">hirschb@si.edu</a> | Ben Hirsch                    | This is one example of coati data from my phd Dissertation. I have more that could be made available.                                 | research    | NA                        | FALSE                   | TRUE              | TRUE                                    | TRUE                      | FALSE               | na                | 2003-04-13 09:53:00.000              | 2003-04-13 21:44:00.000             |                             190 | Radio Transmitter |       | Nasua nasua          | Nasua nasua         | Nasua nasua         | NCBI                | 0.988 | Procyonidae | Mammalia |
| Potos flavus                                                                                                                                                                         |                  | Kays, R. W., and Gittleman, J. L. 2001. The Social Organization of the Kinkajou Potos flavus (Procyonidae). Journal of Zoology 253:491-504.                                                                                                                                                                                                                                                                                                                        | 2009-01-18 16:52:28.850 |                                                   0 |                  |                           | National Science Foundation, National Geographic, University of Tennessee, Smithsonian Tropical Research Institute | TRUE       | FALSE        |      80479 | FALSE    | Contact Roland Kays for permission for professional purposes, ok to use for education.                               | CUSTOM        |              9.1586 |               -79.75 | Kinkajous on Pipeline Road, Panama (1995-1996)                    |                      13 |                      13 |               13 |                                  |                                                                  |                               | Ecology, behavior, and genetics of kinkajous. Radio-tagged kinkajous and followed them on foot to record their location and behavior. |             |                           |                         |                   |                                         |                           |                     |                   |                                      |                                     |                                 |                   |       |                      |                     |                     |                     |       |             |          |

See also Kays, R. W., and Gittleman, J. L. 2001. The Social Organization
of the Kinkajou Potos flavus (Procyonidae). Journal of Zoology
253:491-504.

Kays, R. W., Gittleman, J. G., and Wayne, R. K. 2000. Microsatellite
Analysis of Kinkajou Social Organization. Molecular Ecology 9:743-751.

Kays, R. W. 2000. The Behavior of Olingos (Bassaricyon gabii) and Their
Competition with Kinkajous (Potos flavus) in Central Panama. Mammalia
64:1-10. \|research \|NA \|TRUE \|TRUE \|TRUE \|TRUE \|FALSE \|na
\|1995-10-21 04:00:00.000 \|1996-12-16 04:55:00.000 \| 2867\|Radio
Transmitter \| \|Potos flavus \|Potos flavus \|Potos flavus \|NCBI \|
0.988\|Procyonidae \|Mammalia \| \|Potos flavus \|Funding from NHK for
GPS collars \|Powell RA, Ellwood S, Kays R, Maran T (2017) Stink or
swim: techniques to meet the challenges for the study and conservation
of small critters that hide, swim, or climb, and may otherwise make
themselves unpleasant. In Macdonald DW, Newman C, Harrington LA, eds,
Biology and Conservation of Musteloids. Oxford University Press, Oxford.
p 216–230.
<a href="doi:10.1093/oso/9780198759805.003.0008" class="uri">doi:10.1093/oso/9780198759805.003.0008</a>
\|2011-04-14 10:07:29.862 \| 0\| \| \| \|TRUE \|FALSE \| 2923486\|FALSE
\|These data have been published by the Movebank Data Repository with
DOI &lt;a
href="""“<a href="http://dx.doi.org/10.5441/001/1.41076dq1" class="uri">http://dx.doi.org/10.5441/001/1.41076dq1</a>”"""
target=""""\_blank"""“&gt;10.5441/001/1.41076dq1</a>. \|CUSTOM \|
9.1570\| -79.74\|Kinkajous on Pipeline Road Panama (data from Powell et
al. 2017) \| 2\| 2\| 2\| \| \| \|Preliminary study to test the
performance of GPS collars on kinkajous and map out their use of
flowering and fruiting trees \|research \|NA \|FALSE \|TRUE \|FALSE
\|TRUE \|FALSE \|na \|2010-01-19 01:20:56.000 \|2010-01-23 11:50:56.001
\| 483\|GPS,Acceleration \| \|Potos flavus \|Potos flavus \|Potos flavus
\|NCBI \| 0.988\|Procyonidae \|Mammalia \| \|Procyon lotor \| \|
\|2013-01-19 15:09:51.810 \| 0\| \| \|Leibniz Centre for Agricultural
Landscape Research (ZALF); University of Potsdam \|TRUE \|FALSE \|
8586216\|FALSE \|Do not use in any purpose without contacting the study
owners. \|CUSTOM \| 52.4554\| 13.75\|AgroScapeLabs 2012 Procyon lotor
Germany \| 2\| 2\| 2\| \| \| \| \|research \|NA \|TRUE \|FALSE \|TRUE
\|FALSE \|FALSE \|na \|2012-11-23 06:57:29.999 \|2012-12-13 13:30:57.998
\| 131\|GPS,Acceleration \| \|Procyon lotor \|Procyon lotor \|Procyon
lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \| \|Procyon lotor \| \|
\|2020-06-12 15:29:17.574 \| 0\| \| \| \|TRUE \|FALSE \|
1172328855\|FALSE \| \|CUSTOM \| 53.3776\| 13.77\|Raccoon Procyon lotor
Germany Brandenburg \| 15\| 15\| 15\| \| \| \| \|research \|NA \|FALSE
\|FALSE \|TRUE \|FALSE \|FALSE \|na \|2020-05-22 04:16:54.999
\|2020-07-16 09:00:24.998 \| 15928\|GPS,Acceleration \| \|Procyon lotor
\|Procyon lotor \|Procyon lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia
\| \|Procyon lotor \| \| \|2016-11-02 12:36:55.499 \| 0\| \| \| \|TRUE
\|FALSE \| 210221817\|FALSE \| \|CUSTOM \| 52.5196\| 13.41\|Raccoons of
Berlin \| 18\| 19\| 19\| \| \| \| \|research \|NA \|FALSE \|FALSE \|TRUE
\|FALSE \|FALSE \|na \|2016-09-08 22:22:41.000 \|2020-11-09 08:12:16.000
\| 619938\|GPS,Acceleration \| \|Procyon lotor \|Procyon lotor \|Procyon
lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \| \|Procyon lotor \| \|
\|2018-08-20 20:15:14.282 \| 0\| \| \| \|TRUE \|FALSE \|
552493955\|FALSE \| \|CUSTOM \| 34.4125\| -119.85\|UCSB Urban Raccoon
Project \| 10\| 10\| 10\| \| \| \| \|research \|NA \|FALSE \|FALSE
\|TRUE \|FALSE \|FALSE \|na \|2017-07-28 00:01:00.000 \|2036-02-07
06:28:00.000 \| 23929\|GPS \| \|Procyon lotor \|Procyon lotor \|Procyon
lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \| \|Procyon lotor \| \|
\|2018-01-19 00:00:46.339 \| 0\| \| \| \|TRUE \|FALSE \|
404507471\|FALSE \| \|CUSTOM \| 34.4102\| -119.85\|UCSB Urban Raccoon
Project updated \| 8\| 8\| 8\| \| \| \| \|research \|NA \|FALSE \|FALSE
\|TRUE \|FALSE \|FALSE \|na \|2017-07-28 00:01:00.000 \|2019-04-27
12:26:00.000 \| 23707\|GPS \| \|Procyon lotor \|Procyon lotor \|Procyon
lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \| \|Procyon lotor,Canis
latrans,Vulpes vulpes,Urocyon cinereoargenteus \| \|Bogan DA (2004)
Eastern coyote home range, habitat selection and survival rates in the
Albany Pine Bush landscape. MS Thesis. State University of New York at
Albany. 83
p. <a href="https://mafiadoc.com/boganthesis2004_59bd0a501723ddf2eb9d65cb.html" class="uri">https://mafiadoc.com/boganthesis2004_59bd0a501723ddf2eb9d65cb.html</a>
\|2009-04-28 17:23:19.990 \| 0\| \| \|NYS Museum, Biodiversity Research
Institute \|TRUE \|FALSE \| 236023\|FALSE \|These data have been
published by the Movebank Data Repository with DOI &lt;a
href=”""“<a href="https://doi.org/10.5441/001/1.56pf8220" class="uri">https://doi.org/10.5441/001/1.56pf8220</a>”"""
target=""""\_blank""""&gt;10.5441/001/1.56pf8220</a>. \|CUSTOM \|
42.7176\| -73.86\|Suburban coyotes and other carnivores, Bogan and Kays,
Albany NY \| 33\| 39\| 25\| \| \| \|Since 1970, the coyote (Canis
latrans) has been widespread across all of mainland New York, yet no
study has examined how well coyotes survive in suburban areas in this
region and little is known of their ecological roles or potential to
conflict with people. This study used radio telemetry to monitor the
movements of coyotes in the region and investigate survivorship and
correlates of cause-specific mortality. \|research \|NA \|FALSE \|TRUE
\|FALSE \|TRUE \|FALSE \|na \|2001-04-07 05:01:00.000 \|2003-12-20
06:07:00.000 \| 2258\|Radio Transmitter \| \|Procyon lotor \|Procyon
lotor \|Procyon lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \|
\|Procyon lotor,Vulpes vulpes,Lepus europaeus \| \| \|2011-07-22
09:00:41.925 \| 0\| \| \| \|TRUE \|FALSE \| 4048590\|FALSE \| \|CUSTOM
\| 53.3613\| 13.80\|AgroScapeLabs 2011 Uckermark \| 20\| 20\| 22\| \| \|
\| \|research \|NA \|FALSE \|FALSE \|TRUE \|FALSE \|FALSE \|na
\|2011-05-04 08:19:44.999 \|2011-11-30 23:30:49.998 \|
50979\|GPS,Acceleration \| \|Procyon lotor \|Procyon lotor \|Procyon
lotor \|NCBI \| 0.988\|Procyonidae \|Mammalia \|

</div>
