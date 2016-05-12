CandL_L$ordermonth<-as.factor(CandL_L$ordermonth)
CandL_L$orderyear<-as.factor(CandL_L$orderyear)
CandL_R$ordermonth<-as.factor(CandL_R$ordermonth)
CandL_R$orderyear<-as.factor(CandL_R$orderyear)
CandL$ordermonth<-as.factor(CandL$ordermonth)
CandL$orderyear<-as.factor(CandL$orderyear)

CandL_F$ordermonth<-as.factor(CandL_F$ordermonth)
CandL_F$orderyear<-as.factor(CandL_F$orderyear)


CandL_F$cust_id.1[is.na(CandL_F$cust_id.1)]=CandL_F$cust_id[is.na(CandL_F$cust_id.1)]
CandL_F$cust_id[is.na(CandL_F$cust_id)]=CandL_F$cust_id.1[is.na(CandL_F$cust_id)]

CandL_F$contactyear[is.na(CandL_F$contactyear)]=CandL_F$orderyear[is.na(CandL_F$contactyear)]
CandL_F$contactmonth[is.na(CandL_F$contactmonth)]=CandL_F$ordermonth[is.na(CandL_F$contactmonth)]

CandL_F$orderyear[is.na(CandL_F$orderyear)]=CandL_F$contactyear[is.na(CandL_F$orderyear)]
CandL_F$ordermonth[is.na(CandL_F$ordermonth)]=CandL_F$contactmonth[is.na(CandL_F$ordermonth)]

##countinuously
#INNER(received contact and made purchase)
summary(lm(purchase~mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL))
summary(lm(purchase~mailcount+ctlgcount,data=CandL))

#Right(Made purchase)
summary(lm(purchase~mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_R))
summary(lm(purchase~mailcount+ctlgcount,data=CandL_R))

#Left(recieved contact)
summary(lm(purchase~mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_L))
summary(lm(purchase~mailcount+ctlgcount,data=CandL_L))

#Full
summary(lm(purchase~mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_F))
summary(lm(purchase~mailcount+ctlgcount,data=CandL_F))

##Discretely

#Right(Made purchase)
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth,data=CandL_R))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0),data=CandL_R))

#Left(recieved contact)
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth,data=CandL_L))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0),data=CandL_L))

#Full
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth,data=CandL_F))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0),data=CandL_F))


##mix
#INNER(received contact and made purchase)
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth+mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+mailcount+ctlgcount,data=CandL))

#Right(Made purchase)
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth+mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_R))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+mailcount+ctlgcount,data=CandL_R))

#Left(recieved contact)
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth+mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_L))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+mailcount+ctlgcount,data=CandL_L))

#Full
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+I(mailcount>0):ordermonth+I(ctlgcount>0):ordermonth+mailcount+ctlgcount+mailcount:ordermonth+ctlgcount:ordermonth,data=CandL_F))
summary(lm(purchase~I(mailcount>0)+I(ctlgcount>0)+mailcount+ctlgcount,data=CandL_F))


