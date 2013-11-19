library(dplyr)

fec_cpp <- tbl_cpp(fec)
fec_cpp %.%
  filter(
    contb_receipt_dt > as.Date('2012-05-01') & 
    contb_receipt_dt < as.Date('2012-11-05') &
    contb_receipt_amt > 0 & 
    contb_receipt_amt < 2500
  ) %.%
  group_by(cand_nm) %.%
  summarise(n())

# SELECT cand_nm, sum(contb_receipt_amt) as total
# FROM fec
# WHERE contb_receipt_dt BETWEEN '2012-05-01' and '2012-11-05'
#   AND contb_receipt_amt BETWEEN 0 and 2500
# GROUP BY cand_nm
