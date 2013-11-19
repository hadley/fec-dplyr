# Download all zip files
library(lubridate)

raw <- c(
  "indiv12.zip" = "ftp://ftp.fec.gov/FEC/2012/indiv12.zip"
)

missing <- !file.exists(names(raw))
Map(download.file, raw[missing], names(raw)[missing])

# Unzip, read csv and save as rds
cache <- function(zip_path, rds_path) {
  filename <- unzip(zip_path, list = TRUE)[[1]]  
  unzipped <- unzip(zip_path, filename, exdir = tempdir())
  on.exit(unlink(unzipped))

  df <- read[[zip_path]](unzipped)
  class(df) <- c("tbl_cpp", "tbl", class(df))
  saveRDS(df, rds_path)
}

# List of functions for parsing each individual file
read <- list(
  "indiv12.zip" = function(path) {
    df <- read.delim(unzipped, stringsAsFactors = FALSE, sep = "|", 
      header = FALSE)
    names(df) <- tolower(c("CMTE_ID", "AMNDT_IND", "RPT_TP", "TRANSACTION_PGI", 
      "IMAGE_NUM", "TRANSACTION_TP", "ENTITY_TP", "NAME", "CITY", "STATE", 
      "ZIP_CODE", "EMPLOYER", "OCCUPATION", "TRANSACTION_DT", "TRANSACTION_AMT", 
      "OTHER_ID", "TRAN_ID", "FILE_NUM", "MEMO_CD", "MEMO_TEXT", "SUB_ID"))
    df$transaction_dt <- mdy(df$transaction_dt)
    df
  }
)

cached <- setNames(names(raw), gsub("zip", "rds", names(raw)))
missing <- !file.exists(names(cached))

Map(cache, cached[missing], names(cached)[missing])
