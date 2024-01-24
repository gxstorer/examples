********************************************************************************
****							  Table (6):	 	 						****
****						 	 Diff-in-Diff	 	 						****
********************************************************************************
	use 			"$work_dir/honey_panel_english.dta"	, clear		

	local 		label 		"DiD"

	local 		title		"title("Effect of Honey Producers in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{Baseline}  " "\textbf{Household FE}" " \textbf{Demographic Controls}") "   						
	local 		edu 		" 2.edu_level "Secondary Edu." 3.edu_level "High School Edu." "
	local 		cells 		"collabels("Food Insecurity" "SE")"
	local 		coef		"coeflabels( 1.honey_producer#1.month_honey "Honey Producer x Honey Season" 1.honey_producer "Honey Producer" 1.month_honey "Honey Season" `edu' _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local  		groups 		"refcat(female "\textbf{Controls:}", nolabel)"	
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} "0.00         &      (.)" " & ") "	// (Optional) r2=include r2 in footer. substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"scalars("FE Household fixed effects")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `groups' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey				, $regression
	estadd		local 	FE		"NO"
	eststo:		reghdfe food_insecurity 	honey_producer##month_honey					, $regression absorb(id)
	estadd 		local 	FE 		"YES"
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey female age i.edu_level family_members dependents coop_member coffee_experience , $regression
	estadd		local 	FE 		"NO"
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear
	
********************************************************************************
****							  figure (6):	 	 						****
****						 OLS parallel trends	 	 					****
********************************************************************************							
							
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
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}												
