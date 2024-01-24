********************************************************************************
****					Summary Statistics: Regional Means	  	 			****
********************************************************************************

	use 		"$work_dir/encuesta_miel.dta", clear

** 	local 		stat_vars		"age female edu_level family_members dependents coop_member coffee_experience farm_hectares total_coffee_varietals total_types_crops varietals_resistance_perc coffee_harvest total_income total_income_honey total_food_insecurity region_honey_perc"												// (Manual) // Enter variables that are to be measured.

	local 		region 			" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" " 
	
	local 		label 		"summary_stats"
	
	local 		title		"title("Summary Statistics: Regional Demographic Mean Values""\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		"mtitles("Pop." `region' )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	

	local 		text 		"substitute(centering "centering \scriptsize")"
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	quietly estpost sum $stat_vars 
	
	foreach 	y of numlist 		1 2 3 4 5 6 7 8 9 10 11 {
	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
}	

	esttab 		using 		"$table_dir\table_`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear	

	
********************************************************************************
****	  	       Summary Stats: Honey vs. Non-Honey	 	 				****
****	  					                                				****
********************************************************************************

	local 		label 		"summary_honey"

	local 		title		"title("Summary Statistics: Honey Producers vs. Non-Honey"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.

	gen 		reverse_miel_produce = 0
	replace 	reverse_miel_produce = 1 	if $balance_sample == 0
	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if $balance_sample == 1
	eststo: 	estpost sum 	$stat_vars 		if $balance_sample == 0	
	eststo: 	estpost ttest 	$stat_vars 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 

********************************************************************************
****				Summary Stats: Coffee Varietals 	 					****
****				 	                            	  					****
********************************************************************************		
	
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

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	

********************************************************************************
****					 Summary Stats: Honey Regions	  					****
****					                                	 				****
********************************************************************************
	local 		sample_regions "region_honey"

	local 		label 		"summary_region"

	local 		title		"title("Summary Statistics: Honey Regions vs. Non-Honey Regions"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Regions}" "\textbf{Non-Honey Regions}" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.
	
	gen 		reverse_honey_region = 0
	replace 	reverse_honey_region = 1 	if `sample_regions' == 0
	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if `sample_regions' == 1
	eststo: 	estpost sum 	$stat_vars 		if `sample_regions' == 0	
	eststo: 	estpost ttest 	$stat_vars 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 
	
********************************************************************************
****					 Summary Stats: Cooperative Members	  				****
****					                                	 				****
********************************************************************************	

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

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	