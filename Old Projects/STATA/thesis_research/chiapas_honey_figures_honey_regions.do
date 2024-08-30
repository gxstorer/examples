********************************************************************************
****							  figure (7):	 	 						****
****							Regional Counts	 	 						****
********************************************************************************

use 			"$work_dir/honey_panel_english.dta"	, clear	

/* Honey takeup has an endogeneity problem in that we don't know what causes coffee producers to adopt honey.
But once they do, they typically borrow a starter hive from a neighbor. 
Thus being in a region with a higher percentage of beekeeping neighbors increases the capacity to adopt honey.

Create a variable that calculates the percentage of neighbors in a given community are honey producers.
But remove the individual observation to jacknife the instrument.
*/

	local 		label		"graph_honey_regional_counts"
	local 		legend 		"legend(order(1 "Region Total Population" 2 "Honey Producers" )) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title(" ") ytitle("Regional Counts") "
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar region_producers 	region_honey_producers 	, over(region_survey) /// 
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) ///  
				$graph_hist `locals' 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}								


********************************************************************************
****							  figure (8):	 	 						****
****						Regional Honey Percentage 	 					****
********************************************************************************

	local 		label 		"graph_honey_regional_percent"
	local 		legend 		"legend(order(1 "Region Population" 2 "Honey Producers" )) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title(" ") ytitle("Region Percent") note("Survey regions with >20% honey producer representation are categorized as a honey region in study.")"
	local 		lines 		"yline(.2)"
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar region_honey_perc, over(region_survey) bar(1, color("235 188 78")) ///  
				$graph_hist `locals' 

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir\\`y'\\`label'.`y'		, as(`y') $graph_export
	}								
