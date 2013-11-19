library(dplyr)

indiv <- readRDS("indiv12.rds")

cm <- readRDS("cm14.rds")
cn <- readRDS("cn14.rds")

# Find all committees that represent candidates (house, senate, or president)
cm_cn <- filter(cm, cmte_tp %in% c("H", "S", "P"))
# Add on candidate info
cm_cn <- inner_join(cm_cn, cn, by = "cand_id")
cm_cn2 <- select(cm_cn, cmte_id, cand_id, cmte_nm, cand_name, cand_office, 
  cand_office_st, cmte_pty_affiliation, cand_zip, cand_ici)

# Some (not many) candidates have more than one committee
table(table(cm_cn2$cand_id))

