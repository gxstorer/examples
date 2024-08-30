********************************************************************************
****							 Seasonality Data	 						****
****						                      	 						****
********************************************************************************

	use 			"$work_dir/frequencies.dta"	, clear

	local		label		"graph_seasonal_effects"
	local 		legend 		"legend(order(1 "Coffee Sold" 2 "Honey Sold" 3 "Food Insecurity" )region(fcolor(white)))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"ytitle(Percentage of Annual Occurence)" 			// (Manual) // Axis titles. Remove if n/a. 
	
	local 		locals 		" `legend' `titles' "

	gen 		month_order		 = 1 if month == 11
	replace		month_order		 = 2 if month == 12
	replace		month_order		 = 3 if month == 1
	replace		month_order		 = 4 if month == 2
	replace		month_order		 = 5 if month == 3
	replace		month_order		 = 6 if month == 4
	replace		month_order		 = 7 if month == 5
	replace		month_order		 = 8 if month == 6
	replace		month_order		 = 9 if month == 7
	replace		month_order		 = 10 if month == 8
	replace		month_order		 = 11 if month == 9
	replace		month_order		 = 12 if month == 10
	
	graph 		bar coffee_sales_percent honey_sales_percent food_insecurity_percent, over(month_order, relabel( 1 "Nov" 2 "Dec" 3 "Jan" 4 "Feb" 5 "Mar" 6 "Apr" 7 "May" 8 "Jun" 9 "Jul" 10 "Aug" 11 "Sep" 12 "Oct")) sort(month_order) ///
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) bar(3,color("187 0 0")) /// 
				$graph_hist `locals'
				
	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}				


********************************************************************************
****							 Food Insecurity 	 						****
****						 	                	 	 					****
********************************************************************************	
	
	use 			"$work_dir/honey_panel_english.dta"	, clear

	local 		label 		"graph_food_insecurity_exposure"
	local 		legend 		" " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"ytitle("Food Insecurity Percentage") note("Percentage of Population Experiencing Food Insecurity by Month")"
	local 		lines 		"yline(.25)"
	
	local 		locals 		" `legend' `titles' `lines' "
	
	replace 	food_insecurity = food_insecurity * 100
	gen 		month_order		 = 1 if month == 11
	replace		month_order		 = 2 if month == 12
	replace		month_order		 = 3 if month == 1
	replace		month_order		 = 4 if month == 2
	replace		month_order		 = 5 if month == 3
	replace		month_order		 = 6 if month == 4
	replace		month_order		 = 7 if month == 5
	replace		month_order		 = 8 if month == 6
	replace		month_order		 = 9 if month == 7
	replace		month_order		 = 10 if month == 8
	replace		month_order		 = 11 if month == 9
	replace		month_order		 = 12 if month == 10
	
	graph 		bar food_insecurity, over(month_order, relabel( 1 "Nov" 2 "Dec" 3 "Jan" 4 "Feb" 5 "Mar" 6 "Apr" 7 "May" 8 "Jun" 9 "Jul" 10 "Aug" 11 "Sep" 12 "Oct")) sort(month_order) /// 
				bar(1,color("187 0 0")) $graph_hist `locals' blabel(bar, size(vsmall) format(%3.1f) box) 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}								
	
********************************************************************************
****			     Food Insecurity: Honey vs. Non-honey	 				****
****						                      	 						****
********************************************************************************

	use 			"$work_dir/honey_panel_english.dta"	, clear
	
	local		label		"graph_food_insecurity_honey_nonhoney"
	local 		legend 		"legend(order(1 "Honey Producers" 2 "Non-Honey Producers")) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		 "ytitle("Food Insecurity")  note("Honey season: April - June." "Lean Season: June - August")"
	local 		labels		"blabel(bar, size(vsmall) format(%3.1f) box) ylabel(#10)"
	local 		locals 		" `legend' `titles' `labels'"
	
** Old method:	
//	gen 		coffee_mean = 	(honey_producer==0)
//	gen 		honey_mean 	= 	(honey_producer==1) 
//	collapse 	(mean) 		food_insecurity  			, by(month honey_mean coffee_mean)

//	gen 		type =1 	if honey_mean ==1
//	replace 	type =2 	if coffee_mean 

//	reshape 	wide food_insecurity  honey_mean coffee_mean , i(month) j(type )

	statsby 	food_insecurity1=r(mu_1) food_insecurity2=r(mu_2) t=r(t), by(month) clear: ttest food_insecurity, by(honey_producer)
	replace 	food_insecurity1 = food_insecurity1 * 100
	replace 	food_insecurity2 = food_insecurity2 * 100
	
	gen 		month_order		 = 1 if month == 11
	replace		month_order		 = 2 if month == 12
	replace		month_order		 = 3 if month == 1
	replace		month_order		 = 4 if month == 2
	replace		month_order		 = 5 if month == 3
	replace		month_order		 = 6 if month == 4
	replace		month_order		 = 7 if month == 5
	replace		month_order		 = 8 if month == 6
	replace		month_order		 = 9 if month == 7
	replace		month_order		 = 10 if month == 8
	replace		month_order		 = 11 if month == 9
	replace		month_order		 = 12 if month == 10
	
	graph 		bar food_insecurity1 food_insecurity2 , over(month_order, relabel( 1 "Nov" 2 "Dec" 3 "Jan" 4 "Feb" 5 "Mar" 6 "Apr" 7 "May" 8 "Jun" 9 "Jul" 10 "Aug" 11 "Sep" 12 "Oct")) sort(month_order) /// 
				$graph_hist `locals'

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}								
