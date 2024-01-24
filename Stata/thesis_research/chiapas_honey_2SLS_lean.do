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
	
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear							

********************************************************************************
****						 	 Hausman Test 		   						****
********************************************************************************

												
reg 		food_insecurity 		honey_producer_x_lean_season 	honey_producer  	lean_season 
estimates 	store ols

xtivreg 	food_insecurity 	( 	honey_producer_x_lean_season 	honey_producer ///
								= 	iv_share_lean					region_honey_share ) lean_season
estimates 	store iv

hausman 	iv ols