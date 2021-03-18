[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)


This project scrapes and summarizes data sets available on [Movebank](movebank.org/).
There is a huge diversity of data sources with varying license terms, public access/not, 
taxa. This is an attempt to better understand how accessible relevant data are
for my own project. I'm hoping to wrap this up as a more general-use template, so if 
that's something you would be interested in - please open an issue and we can discuss. 
I'd rather do that with an idea of what others are looking for. In the meantime, 
this can be used and adapted for your own needs. 

We use a number of packages for downloading ([`rmoveapi`](https://github.com/benscarlson/rmoveapi), [`move`](https://gitlab.com/bartk/move/)), processing ([`data.table`](https://github.com/Rdatatable/data.table/), [`anytime`](https://github.com/eddelbuettel/anytime)) and visualizing ([`ggplot2`](https://github.com/tidyverse/ggplot2), [`leaflet`](https://github.com/rstudio/leaflet/)) the data.
All steps are wrapped up in a [`targets`](https://github.com/ropensci/targets) workflow, and package versions tracked with [`renv`](https://github.com/rstudio/renv/). The result is a [`bookdown`](https://github.com/rstudio/bookdown/) doc with each study on it's own page. There's a minimum working example of combining `targets` and `bookdown` available here: [`robitalec/targets-parameterized-bookdown`](https://github.com/robitalec/targets-parameterized-bookdown). Thank you to the developers of all of these great packages. 


## Setup

1. [Register](https://www.movebank.org/cms/webapp?gwt_fragment=page=search_map,action=register) for a Movebank account
1. Save your credentials with [`keyring`](https://github.com/r-lib/keyring/)
1. Edit the credentials section in the targets file (`_targets.R`)
1. Run the setup script to install packages with `renv` and download study data

I've decided to remove the study data download step from the targets workflow 
because during development it was a huge step I didn't want to rerun. I figure
folks will do this step once, so it's not worth hanging up the workflow 
though technically it would be safer and more reliable to have this included. 


## Caveats/lessons learned
If you are hoping to do something similar, I have two main lessons learned:

* Reduce the data to only what you need as quickly as possible, without going far into analysis or processing. This is directly related to...
* The data is not homogeneous. Data types do not appear to be strictly enforced, there are many duplicated study names, and there are NAs or errors throughout. This makes it hard to apply the same functions, or combine different datasets programmatically. 

So reduce down to only the data you need before doing anything too specific. 

Some things to watch out for:

* duplicated study names (see [here](https://gitlab.com/bartk/move/-/issues/52))
* errors in dates (eg. typos, impossible study period date/end ranges)
* taxons provided are often a list of different taxonomies or taxonomic ranks
* pay attention to the [Movebank API doc](https://github.com/movebank/movebank-api-doc)
