# Project: NYC Open Data
### Data folder

The data directory contains data used in the analysis. This is treated as read only; in paricular the R/python files are never allowed to write to the files in here. Depending on the project, these might be csv files, a database, and the directory itself may have subdirectories.



# Project: University data
### Data folder


#### Raw Data
The source of the data is : https://catalog.data.gov/dataset/college-scorecard
And the handbook of the data is : https://collegescorecard.ed.gov/data/documentation/

#### Data Description (mainly the used ones, use find to get specific definition):

The orginal data is composed of thousands of varibales, after cleaning, the one listed here, are parts of the things we use.

INSTNM: institution name;
CITY: the city ther school is in;
STABBR: the shortname of the state the university is in;
ZIP: the zip code of the university, sometimes have more than 5 digit;
ACCREDAGENCY: who somekind gover the university, called accrediotr, always"XX region XX organizaiton";
INSTURL: the link of the university's homepage;
NPCUR: the net cost calculating of the university, provide a link;
HCM2: the cash mangement of school, not used here;
LATITUDE: the latitude of the university, further map application used;
LONGITUDE: the longtitude of the university;
ADM_RATE / ADM_RATE_ALL: the admission rate of the university, the first is for different campus, the later is overall admission rate;
SATVR25/SATVR75/SATMT25/SATMT75/SATWR25/SATWR75/SATVRMID/SATMTMID/SATWRMID/SAT_AVG/SAT_AVG_ALL: everything about SAT, providing percentile data on reading/math/writing;
ACTCM25/ACTCM75/ACTEN25/ACTEN75/ACTMT25/ACTMT75/ACTWR25/ACTWR75/ACTCMMID/ACTENMID/ACTMTMID/ACTWRMID: everything about ACT, providing percentile data;
PCIP(2-digit number): all about what programs the university is providing;
COSTT4_A	TUITIONFEE_IN	TUITIONFEE_OUT	TUITFTE	INEXPFTE	AVGFACSAL	: everything about tuition and cost, the in and out here is different tuition for in/out state students
Rank(without abreast)	Rank  : the rank of the university, scraping from online source, merge with raw data;
