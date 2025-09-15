* BMA with SLX and SDM specification using PM2.5 concentration (log) and 
* SO4 concentration (log) as dependent variables

// Set the directory and upload the data 

clear all
cls

cd "C:\Users\lcpri\OneDrive\Documentos\Research_projects\Econometría\EKC\BMA_results"

use "Full_dataset_pollutants_KNN_matrix.dta"

label variable ln_so4smass "SO4 concentration"
label variable ln_mean_pm25 "PM2.5 concentration"
label variable ln_sum_ntl "Sum of NTL (log)"
label variable ln_sum_ntl_sq "Sum of NTL (log) sq"
label variable ln_mean_precipitations "Precipitations (log)"
label variable ln_mean_temperature "Temperature (log)"
label variable ln_relative_denseveg_area "Dese vegetation (log)"
label variable ln_altitude "Altitude (log)"
label variable ln_educ_expen_pc "Education expenses (log)"
label variable ln_pop_density "Population density (log)"
label variable ln_mean_precipitations_sq "Precipitations (log) sq"
label variable ln_relative_denseveg_area_sq "Dese vegetation (log) sq"
label variable department_capital "Department capital"
label variable fire_big_areas "High fire frequency"

describe
summarize 

// Traditional OLS for PM2.5 concentration (log)

regress ln_mean_pm25 ///
    ln_mean_precipitations ///
	ln_mean_temperature ///
	ln_relative_denseveg_area ///
	ln_altitude ///
	ln_educ_expen_pc ///
	ln_pop_density /// 
	ln_mean_precipitations_sq ///
	ln_mean_ntl ln_mean_ntl_sq fire_big_areas department_capital

// BMA for PM2.5 concentration (log)

/// SLX specification for individual variables

bmaregress ln_mean_pm25 ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density /// 
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
	fire_big_areas department_capital, enumeration saving("pm25_nogrouped", replace)
	
estimates store pm25_nogrouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine
	
///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)

/// SLX specification for grouped variables

bmaregress ln_mean_pm25 ///
    (ln_mean_precipitations w_ln_mean_precipitations) ///
	(ln_mean_temperature w_ln_mean_temperature) ///
	(ln_relative_denseveg_area w_ln_relative_denseveg_area) ///
	(ln_altitude w_ln_altitude) ///
	(ln_educ_expen_pc w_ln_educ_expen_pc) ///
	(ln_pop_density w_ln_pop_density) /// 
	(ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq) fire_big_areas department_capital, saving("pm25_grouped", replace) 

estimates store pm25_grouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine

///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)
	
/// SDM specification for individual variables
	
bmaregress ln_mean_pm25 w_pm25_ortho ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density /// 
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
	fire_big_areas department_capital, enumeration saving("pm25_1ortho_nogrouped", replace)
	
estimates store pm25_1ortho_nogrouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity w_pm25_ortho ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine

///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)

/// SDM specification for grouped variables
	
bmaregress ln_mean_pm25 w_pm25_ortho ///
    (ln_mean_precipitations w_ln_mean_precipitations) ///
	(ln_mean_temperature w_ln_mean_temperature) ///
	(ln_relative_denseveg_area w_ln_relative_denseveg_area) ///
	(ln_altitude w_ln_altitude) ///
	(ln_educ_expen_pc w_ln_educ_expen_pc) ///
	(ln_pop_density w_ln_pop_density) /// 
	(ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq) fire_big_areas department_capital, saving("pm25_2ortho_grouped", replace)

estimates store pm25_2ortho_grouped	

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity w_pm25_ortho ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine

///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)
	
// Log Predictive Score (LPS) for PM2.5 models	

bmastats lps pm25_nogrouped pm25_grouped pm25_1ortho_nogrouped pm25_2ortho_grouped, compact

*****************************************************************************************

//Traditional OLS for SO4 concentration (log)
		
regress ln_so4smass ///
    ln_mean_precipitations ///
	ln_mean_temperature ///
	ln_relative_denseveg_area ///
	ln_altitude ///
	ln_educ_expen_pc ///
	ln_pop_density /// 
	ln_mean_ntl ln_mean_ntl_sq fire_big_areas department_capital
	
//BMA for PM2.5 concentration (log)

/// SLX specification for individual variables
	
bmaregress ln_so4smass ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density /// 
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq fire_big_areas department_capital, enumeration saving("so4_nogrouped", replace)
	
estimates store so4_nogrouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine

///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)
	
/// SLX specification for grouped variables
	
bmaregress ln_so4smass ///
    (ln_mean_precipitations w_ln_mean_precipitations) ///
	(ln_mean_temperature w_ln_mean_temperature) ///
	(ln_relative_denseveg_area w_ln_relative_denseveg_area) ///
	(ln_altitude w_ln_altitude) ///
	(ln_educ_expen_pc w_ln_educ_expen_pc) ///
	(ln_pop_density w_ln_pop_density) /// 
	(ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq) fire_big_areas department_capital, saving("so4_grouped", replace) 

estimates store so4_grouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine
	
///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)

/// SDM specification for individual variables

bmaregress ln_so4smass w_so4smass_ortho ///
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density /// 
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq fire_big_areas department_capital, enumeration saving("so4_1ortho_nogrouped", replace)
	
estimates store so4_1ortho_nogrouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_so4smass_ortho //
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine
	
///Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)
	

/// SDM specification for grouped variables

bmaregress ln_so4smass w_so4smass_ortho ///
    (ln_mean_precipitations w_ln_mean_precipitations) ///
	(ln_mean_temperature w_ln_mean_temperature) ///
	(ln_relative_denseveg_area w_ln_relative_denseveg_area) ///
	(ln_altitude w_ln_altitude) ///
	(ln_educ_expen_pc w_ln_educ_expen_pc) ///
	(ln_pop_density) /// 
	(ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq) fire_big_areas department_capital, saving("so4_2ortho_grouped", replace)

estimates store so4_2ortho_grouped

//// BMA outputs: varmap, posterior distributions, among others

bmagraph varmap
bmagraph pmp  
bmagraph msize
bmastats models, cumulative

bmagraph coefdensity ln_so4smass_ortho //
    ln_mean_precipitations w_ln_mean_precipitations ///
	ln_mean_temperature w_ln_mean_temperature ///
	ln_relative_denseveg_area w_ln_relative_denseveg_area ///
	ln_altitude w_ln_altitude ///
	ln_educ_expen_pc w_ln_educ_expen_pc ///
	ln_pop_density w_ln_pop_density ///
	ln_mean_ntl w_ln_mean_ntl ln_mean_ntl_sq w_ln_mean_ntl_sq ///
    fire_big_areas department_capital, combine
	
/// Creation of credible intervals

bmacoefsample, rseed(18) mcmcsize(10000)
bayesstats summary, clevel(90)
	
// Log Predictive Score (LPS) for SO4 models	

bmastats so4_nogrouped so4_grouped so4_1ortho_nogrouped so4_2ortho_grouped, compact
	
	

	

					 





	

















