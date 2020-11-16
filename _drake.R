source("scripts/plan.R")


if (.Platform$OS.type == "windows") {
	cache <- new_cache(file.path('E:', 'ALR_C2', 'drake-cache'))
} else if (.Platform$OS.type == "unix") {
	cache <- new_cache(file.path('/media', 'ICEAGE', 'drake-cache'))
}

drake_config(plan, cache = cache)
