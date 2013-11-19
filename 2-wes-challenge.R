# A challenge problem from Wes

library(dplyr)
fec_cpp <- readRDS("indiv12.rds")
fec_cpp %.%
  filter(
    transaction_dt > as.Date('2012-05-01') & 
    transaction_dt < as.Date('2012-11-05') &
    transaction_amt > 0 & 
    transaction_amt < 2500
  ) %.%
  group_by(cmte_id) %.%
  summarise(n())
