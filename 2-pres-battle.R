library(dplyr)
library(ggplot2)

cm <- readRDS("cm14.rds")
pres_cm <- cm %.% filter(cmte_tp == "P")

indiv <- readRDS("indiv12.rds")
# Only look at donations to presidential committees
pres <- semi_join(indiv, pres_cm, by = "cmte_id")

daily_cmte <- group_by(pres, cmte_id, transaction_dt)
daily <- summarise(daily_cmte, n = n(), amt = sum(transaction_amt)) %.%
  mutate(cum_amt = cumsum(amt)) %.% filter(transaction_dt > as.Date("2011-01-01"))

# Look only at comittees that raised at least $1 mil
top_cmte <- daily %.% summarise(amt = sum(amt)) %.% dplyr:::filter.tbl_df(amt > 1e6)
daily <- semi_join(daily, top_cmte, by = "cmte_id")

# Match back to candidate names
cn <- readRDS("cn14.rds")

daily <- left_join(daily, select(cm, cmte_id, cand_id))
daily <- left_join(daily, select(cn, cand_id, cand_name))

qplot(transaction_dt, amt, data = daily, geom = "line", colour = cand_name)
qplot(transaction_dt, cum_amt, data = daily, geom = "line", colour = cand_name)
