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
	
	local 		legend 		"legend(order(1 "Total Producers Surveyed in Region" 2 "Honey Producers Surveyed in Region" 3 "Honey Producers Surveyed in Region (pct)") size(vsmall) rows(1)) note("Survey regions to the right of vertical line have >20% honey producer density.")" 	
	
	local 		lines 		"xline(6.5, lcolor(maroon) lwidth(thick)) xlabel(1 "Yalel Mesil (1)" 6 "SJ Paxilha (2)" 4 "Bahtsel (3)" 8 "C.banteljá (4)" 9 "P C.'otanil (5)" 2 "Tumbo (6)" 11 "Tsubute'el (7)" 5 "Coquite'el (8)" 10 "SJ Veracruz (9)" 7 "Ch'iviltic (10)" 3 "Tacuba Vieja (11)", labsize(tiny)) "
	
	local 		titles 		"xtitle(" ") title(" ") ytitle("Regional Counts") "
	
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

	twoway 		(bar region_producers region_honey_order, fcolor("103 71 54") barwidth(.5)) ///
				(bar region_honey_producers region_honey_order, fcolor("235 188 78" 75%) barwidth(.5)) ///
				(scatter region_honey_perc region_honey_order, mcolor(white) mlcolor(black) mlwidth(medthin) yaxis(2)) ///
				, $graph_hist `locals'

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir//`y'/`label'.`y'		, as(`y') $graph_export
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
	graph 		export 		$figure_dir//`y'/`label'.`y'		, as(`y') $graph_export
	}								
