********************************************************************************
****			Income distribution Between Honey & Non-honey				****
****			                                                			****
********************************************************************************

use 							"$work_dir/honey_panel_english.dta", clear

** Types of income

	gen 	perc_income_farm 		= income_farm 			/ 	total_income_honey 
	gen 	perc_income_honey		= income_honey 			/ 	total_income_honey 
	gen 	perc_income_other_work 	= income_other_work 	/ 	total_income_honey 
	gen 	perc_income_other_farm 	= income_other_farm 	/ 	total_income_honey 
	gen 	perc_income_off_farm	= (income_other_work 	+ 	income_other_farm) 	/ total_income_honey	

	local 		label 		"graph_income_sources"
	local 		legend 		"by(, legend(on)) legend(order (1 "Coffee Income" 2 "Honey Income" 3 "Internal Migration Income" 4 "Neighboring Farm Income"))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"by(, title(" ")) ytitle("Region Percent")"
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar (mean) perc_income_farm (mean) perc_income_honey (mean) perc_income_other_work (mean) perc_income_other_farm, by(honey_producer) ///
				$graph_hist `locals' 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}				



********************************************************************************
****				External Income Between Honey & Non-honey 				****
****				                                        	 			****
********************************************************************************	
	
	use 					"$work_dir/honey_panel_english.dta", clear

	local 		label		"graph_income_other"
	local 		legend 		"legend(order(1 "Only Migration" 2 "Only Neighboring" 3 "Migration + Neighboring" 4 "No Off-Farm Income" 5 "FV") size(small) span) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"by(, title(" ")) xtitle("Log Neighboring Farm Income") ytitle("Log Internal Migration Income")"
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "

** Types of income

	gen 	l_income_other_work 	= 	log(income_other_work)
	gen 	l_income_other_farm 	= 	log(income_other_farm)
	replace	l_income_other_work		= 	0	if l_income_other_work == .
	replace	l_income_other_farm		= 	0	if l_income_other_farm == .

		
	twoway 	(scatter l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm ==0, msymbol(triangle)) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work ==0 & l_income_other_farm !=0, msymbol(triangle)) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm !=0 ) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work ==0 & l_income_other_farm ==0 ) ///
			(lfit 	 l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm !=0) ///
			, by(honey_producer) $graph_hist `locals' 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}				
			