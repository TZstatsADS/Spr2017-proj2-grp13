# a function, transform the student infromation into school selection


#Input: SAT(INT), ACT(INT), ZIP(INT),close(T/F), major(string), pay(INT)
#transfer zip to lan and long
install.packages("zipcode")
library(zipcode)
data("zipcode")
loca<-c(zipcode$latitude[zipcode$zip==zip],zipcode$longtitude[zipcode$zip==zip])

#Select the qualified schools
if(is.null(ACT)==TRUE){
  require<-data1$SATVR25<SATV & data1$SATMT25<SATM &  data1$SATWR25<SATW & pay>data1$COSTT4_A
}else{
  require<-data1$ACTCM25<ACT & pay>data1$COSTT4_A        
         }

q.school<-data1[require,]

if(is.null(major)==FALSE){
  q.school<-q.school[q.school[,major]!=0,]
}
 if(close==TRUE){
   q.school$dist<-(q.school$LATITUDE-loca[1])^2+(q.school$LONGTITUDE-loca[2])^2
   q.school<-q.school[order(q.school$dist,decreasing=FALSE),]
   q.school<-q.school[1:10,]
 }else{
   q.school<-q.school[order(q.school$rank,decreasing=FALSE),]
   q.school<-q.school[1:10,]
 }
#Add column
q.school$color<-1/q.school$Rank
q.school$size<-20*(q.school$UGPS/max(q.school$UGPS))
#OUtput






