# Download all zip files
library(lubridate)

source <- c(
  "ftp://ftp.fec.gov/FEC/2012/indiv12.zip",
  "ftp://ftp.fec.gov/FEC/2014/cn14.zip",
  "ftp://ftp.fec.gov/FEC/2014/cm14.zip"
)
target <- basename(source)

missing <- !file.exists(target)
Map(download.file, source[missing], target[missing])

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
    df <- read.delim(path, stringsAsFactors = FALSE, sep = "|", 
      header = FALSE)
    names(df) <- tolower(c("CMTE_ID", "AMNDT_IND", "RPT_TP", "TRANSACTION_PGI", 
      "IMAGE_NUM", "TRANSACTION_TP", "ENTITY_TP", "NAME", "CITY", "STATE", 
      "ZIP_CODE", "EMPLOYER", "OCCUPATION", "TRANSACTION_DT", "TRANSACTION_AMT", 
      "OTHER_ID", "TRAN_ID", "FILE_NUM", "MEMO_CD", "MEMO_TEXT", "SUB_ID"))
    df$transaction_dt <- mdy(df$transaction_dt)
    df
  },
  "cn14.zip" = function(path) {
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCandidateMaster.shtml
    df <- read.delim(path, stringsAsFactors = FALSE, sep = "|", header = FALSE,
      quote = "")
    names(df) <- tolower(c("CAND_ID", "CAND_NAME", "CAND_PTY_AFFILIATION", 
      "CAND_ELECTION_YR", "CAND_OFFICE_ST", "CAND_OFFICE", 
      "CAND_OFFICE_DISTRICT", "CAND_ICI", "CAND_STATUS", "CAND_PCC",
      "CAND_ST1", "CAND_ST2", "CAND_CITY", "CAND_ST", "CAND_ZIP"))
    df
  }, 
  "cm14.zip" = function(path) {
    # http://www.fec.gov/finance/disclosure/metadata/DataDictionaryCommitteeMaster.shtml
    df <- read.delim(path, stringsAsFactors = FALSE, sep = "|", header = FALSE,
      quote = "")
    names(df) <- tolower(c("CMTE_ID", "CMTE_NM", "TRES_NM", "CMTE_ST1", 
      "CMTE_ST2", "CMTE_CITY", "CMTE_ST", "CMTE_ZIP", "CMTE_DSGN", "CMTE_TP",
      "CMTE_PTY_AFFILIATION", "CMTE_FILING_FREQ", "ORG_TP", "CONNECTED_ORG_NM",
      "CAND_ID"))
    df
  }
)

cached <- gsub("zip", "rds", target)
missing <- !file.exists(cached)

Map(cache, target[missing], cached[missing])
