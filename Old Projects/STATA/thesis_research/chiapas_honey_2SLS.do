********************************************************************************
****							  table (7):	 	 						****
****						 2SLS Diff-in-Diff		 	 					****
********************************************************************************

	use 			"$work_dir/honey_panel_english.dta"	, clear	


************     Model (6): Honey producers during honey harvest, with individual fixed effects     **************

	local 		label 		"IV"

	local 		title		"title("Effect of Honey Producers in Honey Season on Food Insecurity"\label{`label'})"				
																				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{OLS}  " "\textbf{1st Stage}" " \textbf{IV}") "   						
	local 		cells 		"collabels("Food Insecurity") drop(honey_producer)"
	local 		coef		"coeflabels(honey_producer_x_honey_season  "Honey Producer x Honey Season" honey_season "Honey Season" region_honey_share "IV: Honey In Region" _cons "Constant" ) nobaselevels"										  // (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} ) "	
																				// (Optional) r2=include r2 in footer. substitute() enters what was in SE

    local 		scalar 		"scalars("FE Household fixed effects" "F F-Statistic")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' " // Compiles all globals together. 
	
	
** User friendly variables  
	gen 	honey_season 					= month_honey
	gen 	honey_producer_x_honey_season 	= honey_producer 		* 	month_honey
	
	eststo clear
	eststo: 	reghdfe 	food_insecurity 	honey_producer_x_honey_season 	honey_season 	honey_producer			, $regression  absorb(id)
	estadd		local 	FE		"YES"
	
***********     Model (7): First Stage 2SLS Regression 	   *******************			
				
	use 				"$work_dir/encuesta_miel.dta", clear

** generate IV of share of honey producers in each survey region within non-panel data form of survey data (encuesta_miel). 


	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if miel_produce == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted
	rename 	miel_produce honey_producer

	eststo:		reg 	honey_producer region_honey_share 
	estadd 		local 	FE 		"NO"
					
***********    Model (8): 2nd Stage 2SLS with IV   ******************				

	use 			"$work_dir/honey_panel_english.dta"	, clear	

** Generate IV
	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if honey_producer == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted

** Interaction terms for IV
	gen 	did_hp_honey 			= honey_producer 		* 	month_honey
	gen 	iv_share_honey			= 	region_honey_share 	* 	month_honey

** User friendly variables 
	gen 	honey_season 					= month_honey
	gen 	honey_producer_x_honey_season 	= did_hp_honey


	eststo: 	xtivreg 	food_insecurity ( ///
													honey_producer_x_honey_season  	honey_producer 		 /// 
												= 	iv_share_honey					region_honey_share 	 /// 
											) ///
													honey_season , fe  $regression
	estadd		local 	FE 		"YES"
	
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear							 

********************************************************************************
****						 	 Hausman Test 		   						****
********************************************************************************

												
reg 		food_insecurity 		honey_producer_x_honey_season 	honey_producer  	honey_season 
estimates 	store ols

xtivreg 	food_insecurity 	( 	honey_producer_x_honey_season 	honey_producer ///
								= 	iv_share_honey					region_honey_share ) honey_season
estimates 	store iv

hausman 	iv ols