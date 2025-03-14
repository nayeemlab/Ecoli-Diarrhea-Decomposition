###################
##2019
###################



clear
*directory
cd "D:\Works\Ecoli-Diarrhea\New\data"

******************************************************************************** 
*DATA MERGE 
********************************************************************************

use "wm" , clear
sort HH1 HH2 LN
save "wm" , replace

use "hh" , clear
sort HH1 HH2
save "hh", replace

use "ch" , clear
sort HH1 HH2 LN
save "ch" , replace



merge using wm.dta
tab _merge
keep if _merge == 3
save "ch" , replace
drop _merge

merge using hh.dta
tab _merge
keep if _merge == 3
save "ch" , replace
drop _merge



********************************************************************************
*WEIGHT, STRATA, CLUSTER VARIABLE FOR THE APPENDED DATA
********************************************************************************
gen wgt=chweight
svyset [pw=wgt],psu(HH1) strata(stratum)


********************************************************************************
*Inclusion and Exclusion
********************************************************************************

#Diarrheaoutcome and key predictor

svy: tab CA1
gen diarrhea =CA1
recode diarrhea 1=1
recode diarrhea 2=0
recode diarrhea 8/9=.
label define diarrhea 1 "Yes" 0 "No"
label values diarrhea diarrhea
tab diarrhea

#household water test (100ml)

**991/992 need to be as NA

replace WQ12 = . if WQ12 == 8
gen hhwq = .
replace hhwq = 0 if WQ26 == 0
replace hhwq = 1 if inlist(WQ26, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
replace hhwq = 2 if WQ26>10
label define hhwqlabel 0 "Low" 1 "Moderate" 2 "High"
label values hhwq hhwqlabel

**maybe there was some other 



#source water test (100ml).

**991/992 need to be as NA

replace WQ27 = . if WQ27 == 991 | WQ27 ==992
gen swq = .
replace swq = 0 if WQ27 == 0
replace swq = 1 if inlist(WQ27, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
replace swq = 2 if WQ27>10
label define swqlabel 0 "Low" 1 "Moderate" 2 "High"
label values swq swqlabel
**not finished




#source of water.

replace WQ12 =. if WQ12 == 8
gen sw = .
replace sw = 0 if WQ12 == 1
replace sw = 1 if WQ12 == 2
replace sw = 2 if WQ12 == 3
label define swlabel 0 "Direct from source" 1 "Covered container" 2 "Uncovered container"
label values sw swlabel
*not finished 


#Source water type (100ml)

replace WS1 = . if WS1 == 99
gen swt = .
replace swt = 1 if inlist(WS1, 11, 12, 13, 14, 21, 31, 41, 51, 91, 92)
replace swt = 0 if WS1!= . & WS1 != 11 & WS1 != 12 & WS1 != 13 & WS1 != 14 & WS1 != 21 & WS1 != 31 & WS1 != 41 & WS1 != 51 & WS1 != 91 & WS1 != 92
label define swtlabel 1 "Improved" 0 "Unimproved"
label values swt swtlabel
**not finished


#Child Age

tab CAGE_11


#Child sex


gen csex = .
replace csex = 0 if HL4 == 1
replace csex = 1 if HL4 == 2
label define csexlabel 0 "Male" 1 "Female"
label values csex csex
**not finished


#Residence

gen residence = .
replace residence = 0 if HH6==2 | HH6==3 | HH6==4
replace residence = 1 if HH6==1 | HH6==5
label define residence 0 "Urban" 1 "Rural"
label values residence residence
**not finished



#Division

gen division = .
replace division = 0 if HH7==10
replace division = 1 if HH7==20
replace division = 2 if HH7==30
replace division = 3 if HH7==40
replace division = 4 if HH7==45
replace division = 5 if HH7==50
replace division = 6 if HH7==55
replace division = 7 if HH7==60
label define division 0 "Barisal" 1 "Chattogram" 2 "Dhaka" 3 "Khulna" 4 "Mymensingh" 5 "Rajshahi" 6 "Rangpur" 7 "Sylhet"
label values division division
**not finished

#Education

replace melevel=. if melevel==9

gen mel = melevel
recode mel 0 = 0
recode mel 1 = 1
recode mel 2 = 2
recode mel 3 = 3
label define mel 0 "P" 1 "LS" 2 "SH" 3 "H"
label values mel mel
**not finished



#Wealth index Status

replace windex5=. if windex5==9

gen windex = windex5
recode windex 1= 0
recode windex 2= 1
recode windex 3= 2
recode windex 4= 3
recode windex 5= 4
label define windex 0 "Poor" 1 "Poor" 2 "Middle" 3 "Rich" 4 "Rich"
label values windex windex
**not finished



#Religion

replace HC1A=. if HC1A==9

gen religion = HC1A
recode religion 1 = 0
recode religion 2 = 1
recode religion 3 = 1
recode religion 4 = 1
label define religion 0 "Islam" 1 "Others" 
label values religion religion
**not finished


#household Head sex

gen hhsex = .
replace hhsex = 0 if HHSEX==1
replace hhsex = 1 if HHSEX==2
label define hhsex 0 "Male" 1 "Female"
label values hhsex hhsex
**not finished


#Mother Age


gen mage = .
replace mage = 0 if WAGE==1
replace mage = 1 if WAGE==2
replace mage = 2 if WAGE==3
replace mage = 3 if WAGE==4
replace mage = 4 if WAGE==5
replace mage = 4 if WAGE==6
replace mage = 4 if WAGE==7
label define mage 0 "15-19" 1 "20-34" 2 "20-34" 3 "20-34" 4 "35+"
label values mage mage
**not finished

#Type of toilet facility


replace WS11=. if WS11==99

gen tf = .
replace tf = 0 if WS11<24
replace tf = 1 if WS11>=24 
label define tf 0 "Improved" 1 "Unimproved" 
label values tf tf
**not finished



#Salt Iodization

replace SA1=. if SA1==99

gen si = .
replace si = 0 if SA1<24
replace si = 1 if SA1>=24 
label define si 0 "Improved" 1 "Unimproved" 
label values si si
**not finished

#Height for Age Stunned.

replace HAZ2=. if HAZ2==99.97 | HAZ2==99.98 | HAZ2==99.99

gen stunned = .
replace stunned = 0 if HAZ2<= -2
replace stunned = 1 if HAZ2> -2
label define stunned 0 "Yes" 1 "No" 
label values stunned stunned
**not finished


#Weight for Age Wasted

replace WHZ2=. if WHZ2==99.97 | WHZ2==99.98 | WHZ2==99.99

gen wasted = .
replace wasted = 0 if WHZ2<= -2
replace wasted = 1 if WHZ2> -2
label define wasted 0 "Yes" 1 "No" 
label values wasted wasted
**not finished


#Household own any animals

replace HC17=. if HC17==9

gen animal = .
replace animal = 0 if HC17==1
replace animal = 1 if HC17==2
label define animal 0 "Yes" 1 "No" 
label values animal animal
**not finished


#househol member

replace HH48=. if HH48==9

gen hhmem = .
replace hhmem = 0 if HH48==1
replace hhmem = 1 if HH48==2
label define hhmem 0 "Small" 1 "Large" 
label values hhmem hhmem
**not finished



#Toilet facility shared

replace WS15=. if WS15==9

gen tfshared = .
replace tfshared = 0 if WS15==1
replace tfshared = 1 if WS15==2
label define tfshared 0 "Yes" 1 "No" 
label values tfshared tfshared
**not finished


#Treat water to make safer for drinking

replace WS9=. if WS9==8 | WS9==9

gen watertreat = .
replace watertreat = 0 if WS9==1
replace watertreat = 1 if WS9==2
label define watertreat 0 "Yes" 1 "No" 
label values watertreat watertreat
**not finished

#Removing missing values

drop if diarrhea==.
drop if hhwq==.


#Adjusted model (Logistic regression model)


logit diarrhea i.CAGE_11 i.csex i.mel i.hhmem i.animal i.windex i.swt i.tf i.tfshared i.hhwq i.sw i.swq i.watertreat i.residence i.division , or



********************************
***Linear Regression
********************************
regress diarrhea CAGE_11 csex mel hhmem animal windex swt tf tfshared hhwq sw swq watertreat residence division



************************************
*Decomposition
************************************

******************************************
*creating dummy variabless
******************************************

tabulate CAGE_11, generate(CAGE_11)
tabulate mel,generate(mel)
tabulate windex,generate(windex)
tabulate hhwq,generate(hhwq)
tabulate sw,generate(sw)
tabulate swq,generate(swq)
tabulate mage,generate(mage)
tabulate religion,generate(religion)
tabulate division,generate(division)

CAGE_11 mel windex hhwq sw swq mage religion division

****************
*approach-2
****************
***CONCENTRATION INDEX - CORRECTED VERSION
gen wind = windex
egen raw_rank = rank(wind), unique
sort raw_rank
quietly summ wgt
gen wi=wgt/r(sum)
gen cumsum=sum(wi)
gen wj=cumsum[_n-1]
replace wj=0 if wj==.
gen rank=wj+0.5*wi
drop raw_rank wi cumsum wj

qui sum diarrhea [aw=wgt]
scalar mean=r(mean)
cor diarrhea rank [aw=wgt], covariance
sca CI=8*r(cov_12)
display "concentration index by convenient covariance method", CI

***Computing the semi-elasticities, CI and contributions of each factor
clear matrix
#Creating dummy variable

*global X "mage1 mage2 mage3 numch1 numch2 wp1 wp2 wp3 birthord1 birthord2 birthord3 birthord4 lpb1 lpb2 lpb3 mcoh1 mcoh2 mcoh3 mcoh4 mcoh5 mcoh6 mcoh7 hhage1 hhage2 hhage3 hhage4 pelevel1 pelevel2 pelevel3 pelevel4 pelevel5 wind1 wind2 wind3 wind4 wind5 decision1 decision2 decision3 decision4"
*global X "mage numch wp birthord lpb mcoh hhage pelevel wind"

*global X "mage numch wp mcu religion hhage pelevel melevel cworking wind media division hhocu"

global X " CAGE_111 CAGE_112 CAGE_113 CAGE_114 CAGE_115 mel1 mel2 mel3 mel4 windex1 windex2 windex3 windex4 windex5 hhwq1 hhwq2 hhwq3 sw1 sw2 sw3 swq4 swq5 swq6 mage1 mage2 mage3 mage4 mage5 mage6 religion1 division1 division2 division3 division4 division5 division6 division7 division8 "

regress diarrhea $X [pw=wgt], robust cluster(v001)

*******decomposition starts here
foreach x of global X {
qui {
scal b_`x'=_b[`x']
corr rank `x' [aw=wgt], c
sca cov_`x'=r(cov_12)
sum `x' [aw=wgt]
sca elas_`x'=(b_`x'*r(mean))
sca CI_`x'=8*cov_`x'
sca con_`x'=4*(elas_`x'*CI_`x')
sca prcnt_`x'=(con_`x'/CI)*100


}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

#matrix new = J(100,4,0)\(elas_`x', CI_`x', con_`x', prcnt_`x')
matrix new = nullmat(new)\(elas_`x', CI_`x', con_`x', prcnt_`x')

}
matrix rownames new= $X
matrix colnames new = "Elasticity""CI""Absolute""%"
matrix list new, format(%8.4f)
