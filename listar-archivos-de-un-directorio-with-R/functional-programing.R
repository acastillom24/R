library(purrr)

out1 <- vector(mode = "double", length = ncol(mtcars))

for(i in seq_along(mtcars)){
  out1[[i]] <- mean(x = mtcars[[i]], na.rm = T)
}

out2 <- vector(mode = "double", length = ncol(mtcars))

for(i in seq_along(mtcars)){
  out2[[i]] <- median(x = mtcars[[i]], na.rm = T)
}


out1 <- mtcars %>% map_dbl(.f = mean, na.rm = T)

out2 <- mtcars %>% map_dbl(.f = median, na.rm = T)

# Data from:
# https://www.gov.uk/government/statistics/family-food-open-data

library(fs)
dir_delete(path = "nfs")
dir_create(path = "nfs")

paths <- dir_ls(path = "", glob = "*.zip")
paths <- setdiff(x = paths, y = "")
paths

x <- paths[[1]]
unzip(x, list = T)
unzip(x, list = T)$Name

 