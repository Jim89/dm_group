

#For people who has made a purchase
#Overall
knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R)))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R)))
#In different month
knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==1,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==1,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==2,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==2,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==3,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==3,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==4,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==4,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==5,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==5,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==6,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==6,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==7,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==7,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==8,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==8,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==9,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==9,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==10,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==10,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==11,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==11,])))

knitr::kable(broom::tidy(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==12,])))
knitr::kable(broom::glance(lm(purchase~mailcount+ctlgcount,data=CandL_R[as.character(CandL_R$ordermonth)==12,])))

