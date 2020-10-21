source("scripts/plan.R")


cache <- new_cache('/media/ICEAGE/drake-cache/')
drake_config(plan,
						 cache = cache)
