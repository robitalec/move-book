source("scripts/plan.R")


cache <- new_cache('/media/Backup Plus/drake-cache/')
drake_config(plan,
						 cache = cache)
