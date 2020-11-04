# NPP Products in EE

## ee.ImageCollection("UMT/NTSG/v2/LANDSAT/NPP") and ee.ImageCollection("UMT/NTSG/v2/LANDSAT/GPP")

1986-01-01T00:00:00 - 2019-01-01T00:00:00

The Landsat Net Primary Production (NPP) CONUS dataset estimates NPP using Landsat Surface Reflectance for CONUS. NPP is the amount of carbon captured by plants in an ecosystem, after accounting for losses due to respiration. NPP is calculated using the MOD17 algorithm (see MOD17 User Guide) with Landsat Surface Reflectance, gridMET, and the National Land Cover Database.

* Yearly
* US only


## ee.ImageCollection("UMT/NTSG/v2/MODIS/NPP") and ee.ImageCollection("UMT/NTSG/v2/MODIS/GPP")

2001-01-01T00:00:00 - 2019-01-01T00:00:00

The MODIS Net Primary Production (NPP) CONUS dataset estimates NPP using MODIS Surface Reflectance for CONUS. NPP is the amount of carbon captured by plants in an ecosystem, after accounting for losses due to respiration. NPP is calculated using the MOD17 algorithm (see MOD17 User Guide) with MODIS Surface Reflectance, gridMET, and the National Land Cover Database.

* Yearly
* US only

## ee.ImageCollection("MODIS/006/MOD17A3HGF")

2001-01-01T00:00:00 - 2019-01-01T00:00:00

The MOD17A3HGF V6 product provides information about annual Net Primary Productivity (NPP) at 500m pixel resolution. Annual NPP is derived from the sum of all 8-day Net Photosynthesis (PSN) products (MOD17A2H) from the given year. The PSN value is the difference of the Gross Primary Productivity (GPP) and the Maintenance Respiration (MR) (GPP-MR).

* Yearly
* Global but some masked


## ee.ImageCollection("MODIS/006/MOD17A2H") and ee.ImageCollection("MODIS/006/MYD17A2H")

2000-03-05T00:00:00 - 2020-10-23T00:00:00

The MOD17A2H V6 Gross Primary Productivity (GPP) product is a cumulative 8-day composite with a 500m resolution. The product is based on the radiation-use efficiency concept and can be potentially used as inputs to data models to calculate terrestrial energy, carbon, water cycle processes, and biogeochemistry of vegetation.

2002-07-04T00:00:00 - 2020-10-23T00:00:00

The MYD17A2H V6 Gross Primary Productivity (GPP) product is a cumulative 8-day composite with a 500m resolution. The product is based on the radiation-use efficiency concept and can be potentially used as inputs to data models to calculate terrestrial energy, carbon, water cycle processes, and biogeochemistry of vegetation.

* 8-day
* Global but some gaps
* **TODO**: check QC at gaps/in winter




TODO: look at "npp"
