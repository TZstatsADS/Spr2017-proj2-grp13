data<-read.csv("raw.csv")
sele<-c("INSTNM","MN_EARN_WNE_P7","MN_EARN_WNE_P6","MN_EARN_WNE_P8","MN_EARN_WNE_P9",
        "MN_EARN_WNE_P10")
data1<-data[,sele]
data0<-read.csv("MERGED2014_15_PP.csv")
sele0<-c("CITY","STABBR","INSTURL","LO_INC_DEBT_MDN","MD_INC_DEBT_MDN","HI_INC_DEBT_MDN","LOAN_EVER","CONTROL")
data2<-data0[,sele0]
all<-cbind(data1,data2)
all$CONTROL<-ifelse(all$CONTROL==1,"Public","Private")


