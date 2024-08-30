********************************************************************************
****					Summary Statistics: Regional Means	  	 			****
********************************************************************************
/*
	use 		"$work_dir/encuesta_miel.dta", clear

** 	local 		stat_vars		"age female edu_level family_members dependents coop_member coffee_experience farm_hectares total_coffee_varietals total_types_crops varietals_resistance_perc coffee_harvest total_income total_income_honey total_food_insecurity region_honey_perc"												// (Manual) // Enter variables that are to be measured.

	local 		region 			" "1" "2" "3" "6" "8" "11" "4" "5" "7" "9" "10" " 
	
	local 		label 		"summary_stats"
	
	local 		title		"title("Summary Statistics: Regional Demographic Mean Values""\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		" mtitles("Overall" `region' )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" quintal "\textbf{Outcome Variables:}", nolabel)"	

	local 		text 		"substitute(centering "centering \scriptsize" Observations "Participants") addnotes("Regions with \textgreater 20\% of participants producing honey are categorized as a Honey Region")"
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	quietly estpost sum $stat_vars 
	
//	foreach 	y of numlist 		1 2 3 4 5 6 7 8 9 10 11 {
//	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
//}	

	foreach 	y of numlist 		1 2 3 6 8 11 4 5 7 9 10 {
	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
}	
	esttab 		using 		"$table_dir/table_`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear	
*/

********************************************************************************
****				Summary Stats: Coffee Varietals 	 					****
****				 	                            	  					****
********************************************************************************		
/*	
	local 		label 		"varietals"

	local 		vars 		"variedades_garnica variedades_bourbon variedades_caturra variedades_mundo_novo variedades_typica variedades_maragogype variedades_pacamara variedades_oro_azteca variedades_catimore variedades_geisha variedades_tabi variedades_robusta total_varietals_resistant total_varietals_susceptible varietals_resistance_perc"
	
	local 		title		"title("Coffee Varieties: Honey Producers vs. Non-Honey Producers"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(variedades_garnica "\textbf{  Susceptible to CLR:}" variedades_oro_azteca "\textbf{  Resistant to CLR:}" total_varietals_resistant "\textbf{  Resistant vs. Susceptible:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.
	
	eststo 		clear
	eststo: 	estpost sum 	`vars' 		if $balance_sample == 1
	eststo: 	estpost sum 	`vars' 		if $balance_sample == 0	
	eststo: 	estpost ttest 	`vars' 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir/table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	
*/

********************************************************************************
****				Summary Stats: Regional Demographics 	 				****
****				 	                            	  					****
********************************************************************************

/*
	use 		"$work_dir/survey_location_points.dta", clear

	local 		label 		"summary_communities"
	
	local 		communities "community_pop community_altitude_meters nearest_town_distance_km community_illiterate community_spanish community_houses_electricity community_houses_tv community_houses_car community_houses_cellphone community_houses_internet"

	local 		title		"title("Summary Statistics: Regional Demographics" "Honey Producers vs. Non-Honey"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		" "	
	
	local 		text 		"substitute(centering "centering \small" Observations "Regions")"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.

	gen 		reverse_honey_regions = 0
	replace 	reverse_honey_regions = 1 	if region_honey == 0
	
	eststo 		clear
	eststo: 	estpost sum 	`communities' 		if region_honey == 1
	eststo: 	estpost sum 	`communities' 		if region_honey == 0	
	eststo: 	estpost ttest 	`communities' 		, by(reverse_honey_regions) unequal

	esttab 		using 		"$table_dir/table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	
*/	
	
********************************************************************************
****					 Summary Stats: Cooperative Members	  				****
****					                                	 				****
********************************************************************************	
/*
	local 		label 		"summary_coop"

	local 		title		"title("Summary Statistics:" "Cooperative Members vs. Non-Cooperative"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Coop Members}" "\textbf{Non-Coop Producers}" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel) drop(coop_member)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.

	gen 		reverse_coop = 1 if coop_member == 0
	replace 	reverse_coop = 0 if coop_member == 1
	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if coop_member == 1
	eststo: 	estpost sum 	$stat_vars 		if coop_member == 0	
	eststo: 	estpost ttest 	$stat_vars 		, by(reverse_coop) unequal

	esttab 		using 		"$table_dir/table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	
*/

********************************************************************************
****							  figure (6):	 	 						****
****						 OLS parallel trends	 	 					****
********************************************************************************							
/*							
	use 			"$work_dir/honey_panel_english.dta"	, clear							

** Collapse Monthly Food Insecurity Data 

	gen 	coffee_mean = (honey_producer==0)
	gen 	honey_mean 	= (honey_producer==1) 
	collapse (mean) food_insecurity (sd) sd=food_insecurity (semean) se=food_insecurity , by(month_honey honey_mean coffee_mean)

	gen 	type =1 	if honey_mean ==1
	replace type =2 	if coffee_mean 
	drop 	sd se

	reshape wide food_insecurity  honey_mean coffee_mean , i(month_honey) j(type )

** Manually Create Parallel Trends

	gen 		predict_a 	= 	food_insecurity2
	replace 	predict_a 	= 	-predict_a 			if month_honey ==0
	egen 		predict_b 	= 	total(predict_a)
	replace 	predict_a 	= 	predict_b 			if month_honey ==1
	replace 	predict_a 	= 	food_insecurity1 	if month_honey ==0
	egen 		predict_c 	= 	total(predict_a)
	replace 	predict_c 	= 	predict_a 			if month_honey ==0
	rename 		predict_c	 	predict_honey

** Create Graph

	local 		label 		"graph_parallel_trends"
	local 		legend	 	"legend(order(1 "Honey Producers" 2 "Non-Honey Producers" 3 "Parallel Trend for Honey Producers") region(fcolor(white)) size(small) span)" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles		"title(" ") xtitle("Non-Honey Season vs. Honey Harvest Season") ytitle(Food Insecurity Percentage)" 						// (Manual) // Axis titles. Remove if n/a. 
	local 		xline		"xlabel(0.01 "(Jul-Feb)" 0.97 "(Mar-Jun)")"		 	// (Manual) // Placement on x-axis, followed by color and thickness.
// 																								  Remove all string except for "" if not used.			
	local 		locals 		"`legend' `titles' `xline'" 						// (Optional) Add any new locals to the command 
	
	twoway 		(line food_insecurity1 month_honey, lcol(edkblue) lwidth(thick)) /// 
				(line food_insecurity2 month_honey, lwidth(thick)) /// 
				(line predict_honey month_honey, lcol(edkblue) lwidth(thick) lpattern(dash)) /// 
				,  $graph_twoway `locals'
				
	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir/`y'/`label'.`y'		, as(`y') $graph_export
	}												
*/	

********************************************************************************
****							  figure (7):	 	 						****
****							Regional Counts	 	 						****
********************************************************************************

/*
	local 		label		"graph_honey_regional_counts"
	local 		legend 		"legend(order(1 "Region Surveyed Population" 2 "Honey Producers" )) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title(" ") ytitle("Regional Counts") "
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "
	
	gen 		region_honey_order = 1 if region_survey == 1
	replace 	region_honey_order = 2 if region_survey == 6
	replace 	region_honey_order = 3 if region_survey == 11
	replace 	region_honey_order = 4 if region_survey == 3
	replace 	region_honey_order = 5 if region_survey == 8
	replace 	region_honey_order = 6 if region_survey == 2
	replace 	region_honey_order = 7 if region_survey == 10
	replace 	region_honey_order = 8 if region_survey == 4
	replace 	region_honey_order = 9 if region_survey == 5
	replace 	region_honey_order = 10 if region_survey == 9
	replace 	region_honey_order = 11 if region_survey == 7	
	
	graph 		bar region_producers 	region_honey_producers 	, over(region_honey_order, relabel( 1 "Yalel Mesil(01)" 6 "SJ Paxilha(02)" 4 "Bahtsel(03)" 8 "C.banteljá(04)" 9 "P C.'otanil(05)" 2 "Tumbo(06)" 11 "Tsubute'el(07)" 5 "Coquite'el(08)" 10 "SJ Veracruz(09)" 7 "Ch'iviltic(10)" 3 "Tacuba Vieja(11)") label(labsize(tiny))) sort(region_honey_order) /// 
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) ///  
				$graph_hist `locals' 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}								
*/

/*
********************************************************************************
****							  Table (6):	 	 						****
****						 	 Diff-in-Diff	 	 						****
********************************************************************************
	use 			"$work_dir/honey_panel_english.dta"	, clear		

	local 		label 		"DiD"

	local 		title		"title("Effect of Honey Production in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{Baseline}  " "\textbf{Household FE}" " \textbf{All Controls}") "   						
	local 		cells 		"collabels("Food Insecurity\textsuperscript{1}" "SE") keep(1.honey_producer#1.month_honey 1.honey_producer 1.month_honey _cons)"
	local 		coef		"coeflabels( 1.honey_producer#1.month_honey "Honey Producer x Honey Season\textsuperscript{2}" 1.honey_producer "Honey Producer" 1.month_honey "Honey Season\textsuperscript{2}" _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		" substitute("centering" "centering \small" "Standard" "`SE' standard" "0.00         &        0.02" " (.)         &        0.02" "(.)" " ") "	// (Optional) substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"r2 noobs scalars("Obs Observations" "Subjects Participants" "Months Months" "r2 R\textsuperscript{2}" "FE \hline Household Fixed Effects" "Regional Regional Controls" "Demo Demographic Controls\textsuperscript{3}")"
	
	local 		notes		" addnotes("1. The dependent variable is a dummy which equals 1 if the producer reports food insecurity in a" "given month, 0 otherwise." "2. Honey Season is a dummy which equals 1 if the observed month is either March, April, May" "or June, 0 for all other months." "3. Demographic Controls: Age, Gender, Education Level, Household Size, Dependents," "Coffee Experience, Farm Size, Coffee Harvest, Income.")"
	
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `notes' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey				, $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE			"NO"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 		"3,300"	
	
	eststo:		reghdfe food_insecurity 	honey_producer##month_honey					, $regression absorb(id)
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd 		local 	FE 			"YES"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 	 	"3,300"	
	
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey female age i.edu_level family_members dependents i.region_survey coffee_experience farm_hectares quintal total_income , $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE 			"NO" 
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"YES"
	estadd 		local 	Obs 	 	"3,300"	
	
	esttab 		,										$stars $reg_format `locals'
	esttab 		using  		"$table_dir/table_`label'", $stars $reg_format `locals'
	eststo clear
*/

/*
********************************************************************************
****					Robustness Check 2SLS Lean Months	 				****
****				                                    	 				****
********************************************************************************

	use 			"$work_dir/honey_panel_english.dta"	, clear	


************     Model (6): Honey producers during honey harvest, with individual fixed effects     **************

	local 		label 		"IV_lean"
	local 		title		"title("Robustness Check: Lean Season as Treatment Period"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
	local 		columns 	"mtitles("  \textbf{OLS}  " "\textbf{1st Stage}" " \textbf{IV}") "   						
	local 		cells 		"collabels("Food Insecurity") drop(honey_producer)"
	local 		coef		"coeflabels(honey_producer_x_lean_season  "Honey Producer x Lean Season" lean_season "Lean Season" region_honey_share "IV: Honey In Region" _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} ) "	// (Optional) r2=include r2 in footer. substitute() enters what was in SE

    local 		scalar 		"scalars("FE Household fixed effects" "F F-Statistic")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' " // Compiles all globals together. 

*********      Model (6) lean robustness: Honey producers during lean season, with individual fixed effects  *********

** User friendly variables  
	gen 	lean_season 					= month_lean
	gen 	did_hp_lean 					= honey_producer 		* 	month_lean
	gen 	honey_producer_x_lean_season 	= did_hp_lean

	eststo clear
	eststo: 	reghdfe 	food_insecurity 	honey_producer_x_lean_season 	lean_season 	honey_producer			, $regression  absorb(id)
	estadd		local 	FE		"YES"
				
********    Model (7) lean robustness: First Stage 2SLS Regression 	 ************			
			
	use 				"$work_dir/encuesta_miel.dta", clear
	
** generate IV of share of honey producers in each survey region within non-panel data form of survey data (encuesta_miel). 
	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if miel_produce == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted
	rename 	miel_produce honey_producer

	eststo:		reg 	honey_producer region_honey_share 
	estadd 		local 	FE 		"NO"
					
					
**********   Model (8) lean robustness: 2nd Stage 2SLS with IV       ***************				

use 			"$work_dir/honey_panel_english.dta"	, clear	

** Generate IV

gen 	region_producers_adjusted					= region_producers - 1
gen 	region_honey_producers_adjusted 			= region_honey_producers
replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if honey_producer == 1
gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted

** Interaction terms for IV
gen 	did_hp_lean 			= honey_producer 		* 	month_lean
gen 	iv_share_lean			= region_honey_share 	* 	month_lean

** User friendly variables 
gen 	lean_season 					= month_lean
gen 	honey_producer_x_lean_season 	= did_hp_lean


	eststo: 	xtivreg 	food_insecurity ( ///
													honey_producer_x_lean_season  	honey_producer 		 /// 
												= 	iv_share_lean					region_honey_share 	 /// 
											) ///
													lean_season , fe  $regression
	estadd		local 	FE 		"YES"
	
	esttab												,$stars $reg_format $reg_cells `locals' 
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear							
*/
