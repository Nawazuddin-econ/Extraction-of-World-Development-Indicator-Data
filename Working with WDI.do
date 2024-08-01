
If you intend to utilize data from the 'World Development Indicator (WDI),' the provided codes will be beneficial for your use. I have specifically extracted data for chosen countries, and you have the flexibility to modify the country names. All indicators from the WDI are included in this extraction. You can opt to work with a subset of indicators by removing unnecessary data. I recommend organizing the data initially and subsequently eliminating the indicators that are not required.




**Change Directory
cd "F:\Hard_Drive_Toshiba\CQLA" //Give your own directory name
dir
dir *xlsx
**Import Excel
import excel "F:\Hard_Drive_Toshiba\Asif_bhai\WDI_BRICS_all_inicators",  sheet("Data") firstrow clear
**select some countries. Here BRICS for Example
keep if CountryCode=="BRA" | CountryCode=="IND" | CountryCode=="CHN" | CountryCode=="ZAF" | CountryCode=="RUS"
tab CountryName //see country names
gen n=_n
br
keep if _n<=7390 //remove if there are extra rows
**Convert data in the long format
reshape long YR, i( CountryName SeriesName ) j(year)
br
ren YR value 
gen newv1=1 if CountryCode=="BRA"
replace newv1=2 if   CountryCode=="RUS" 
replace newv1=3 if CountryCode=="IND"
replace newv1=4 if CountryCode=="CHN"
replace newv1=5 if CountryCode=="ZAF"
sort newv1 SeriesName year
by newv1 SeriesName: gen Y_n=_n
egen  id=concat(newv1 Y_n)
sort SeriesName
drop n
gen n=_n
tab SeriesName
 mata 465570/315 //total obs./series freq.
xtile series_code = n , nq(1478)
sort newv1 SeriesName year
save WDI_BRICS_all_indicators
drop SeriesName
**The follwoing command will take some time
forvalues i = 1/1478 {
    preserve
        keep if series_code == `i'
		ren value value_`i' 
        save "series_`i'.dta", replace
    restore
}
**This too will take some time
use "series_1.dta", clear
forval i = 2/1478 {  
 merge 1:1 id using "series_`i'", nogen  
}
save WDI_BRICS_all_indi_values.dta

***Replace .. with . as missing values
forval i= 1/1478 {
 
 replace value_`i'="." if value_`i'==".."
   
 }
 **Delete the series_`i'.dta files
 !del *series*.dta
destring value_*,replace
**Your data it ready. Now you can choose some indicators for analysis. For Example
keep value_1201 value_1444 value_1381 value_671 value_1174 value_138 value_137 value_139 value_543 value_474 value_477 value_318 value_389 value_987 value_1207   CountryName year Y_n id n series_code

label var value_1201 "Renewable energy consumption (% of total final energy consumption)"
label var value_1444 "Urban population (% of total)"
label var value_1381 "Total natural resources rents (% of GDP)"
label var value_671 "Investment in energy with private participation (current US$)"
label var value_1174 "Public private partnerships investment in energy (current US$) "
label var value_138 "CO2 emissions (kt)	"
label var value_137 "CO2 emissions (kg per PPP $ of GDP)"
label var value_139 "CO2 emissions (metric tons per capita)"
label var value_543 "Gross fixed capital formation (% of GDP)"
label var value_474 "GDP (current US$)"
label var value_477 "GDP growth (annual %)"	
label var value_318 "Domestic credit to private sector by banks (% of GDP)"
label var value_389 "Energy intensity level of primary energy (MJ/$2017 PPP GDP)"
label var value_987 "Patent applications, residents"
label var value_1207 "Research and development expenditure (% of GDP)"
save,replace






***************************************************




_______________________________________


label var value_1201 "Renewable energy consumption (% of total final energy consumption)"
label var value_1444 "Urban population (% of total)"
label var value_1381 "Total natural resources rents (% of GDP)"
label var value_671 "Investment in energy with private participation (current US$)"
label var value_1174 "Public private partnerships investment in energy (current US$) "
label var value_138 "CO2 emissions (kt)	"
label var value_137 "CO2 emissions (kg per PPP $ of GDP)"
label var value_139 "CO2 emissions (metric tons per capita)"
label var value_321 "Heat Index 35 "
label var value_4321 "Heating Degree Days "
label var value_543 "Gross fixed capital formation (% of GDP)"
label var value_474 "GDP (current US$)"
label var value_477 "GDP growth (annual %)"	
label var value_318 "Domestic credit to private sector by banks (% of GDP)"
label var value_389 "Energy intensity level of primary energy (MJ/$2017 PPP GDP)"
label var value_987 "Patent applications, residents"
label var value_1207 "Research and development expenditure (% of GDP)"

tsset year

foreach i of num 1201 1444 1381 671 1174 138 137 139 543 474 477 318 389 987 1207 321 4321 {
 destring value_`i',replace
ipolate value_`i' year, gen(xvalue_`i') epolate
}


foreach i of num 1201 1444 1381 671 1174 138 137 139 543 474 477 318 389 987 1207 321 4321 {
order xvalue_`i', after(value_`i') 
}


label var xvalue_1201 "Renewable energy consumption (% of total final energy consumption)"
label var xvalue_1444 "Urban population (% of total)"
label var xvalue_1381 "Total natural resources rents (% of GDP)"
label var xvalue_671 "Investment in energy with private participation (current US$)"
label var xvalue_1174 "Public private partnerships investment in energy (current US$) "
label var xvalue_138 "CO2 emissions (kt)	"
label var xvalue_137 "CO2 emissions (kg per PPP $ of GDP)"
label var xvalue_139 "CO2 emissions (metric tons per capita)"
label var xvalue_321 "Heat Index 35 "
label var xvalue_4321 "Heating Degree Days "
label var xvalue_543 "Gross fixed capital formation (% of GDP)"
label var xvalue_474 "GDP (current US$)"
label var xvalue_477 "GDP growth (annual %)"	
label var xvalue_318 "Domestic credit to private sector by banks (% of GDP)"
label var xvalue_389 "Energy intensity level of primary energy (MJ/$2017 PPP GDP)"
label var xvalue_987 "Patent applications, residents"
label var xvalue_1207 "Research and development expenditure (% of GDP)"


foreach i of num 1201 1444 1381 671 1174 138 137 139 543 474 477 318 389 987 1207 321 4321 {
gen lnxvalue_`i'=log(xvalue_`i')
}


foreach i of num 1201 1444 1381 671 1174 138 137 139 543 474 477 318 389 987 1207 321 4321 {
order lnxvalue_`i', after(xvalue_`i') 
}


label var lnxvalue_1201 "Renewable energy consumption (% of total final energy consumption)"
label var lnxvalue_1444 "Urban population (% of total)"
label var lnxvalue_1381 "Total natural resources rents (% of GDP)"
label var lnxvalue_671 "Investment in energy with private participation (current US$)"
label var lnxvalue_1174 "Public private partnerships investment in energy (current US$) "
label var lnxvalue_138 "CO2 emissions (kt)	"
label var lnxvalue_137 "CO2 emissions (kg per PPP $ of GDP)"
label var lnxvalue_139 "CO2 emissions (metric tons per capita)"
label var lnxvalue_321 "Heat Index 35 "
label var lnxvalue_4321 "Heating Degree Days "
label var lnxvalue_543 "Gross fixed capital formation (% of GDP)"
label var lnxvalue_474 "GDP (current US$)"
label var lnxvalue_477 "GDP growth (annual %)"	
label var lnxvalue_318 "Domestic credit to private sector by banks (% of GDP)"
label var lnxvalue_389 "Energy intensity level of primary energy (MJ/$2017 PPP GDP)"
label var lnxvalue_987 "Patent applications, residents"
label var lnxvalue_1207 "Research and development expenditure (% of GDP)"



