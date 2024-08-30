
********************************************************************************
****			Summary Statistics: Regional Means (non-honey)	  			****
********************************************************************************

	use 		"$work_dir/encuesta_miel.dta", clear

** 	local 		stat_vars		"age female edu_level family_members dependents coop_member coffee_experience farm_hectares total_coffee_varietals total_types_crops varietals_resistance_perc coffee_harvest total_income total_income_honey total_food_insecurity region_honey_perc"												// (Manual) // Enter variables that are to be measured.

	local 		region 			" "1" "2" "3" "6" "8" "11" " 
	
	local 		label 		"table_summary_stats_nonhoney"
	
	local 		title		"title("Summary Statistics by Region (Non-Honey Regions)" "\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		" mtitles("Overall" `region' )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" quintal "\textbf{Outcome Variables:}", nolabel)"	

	local 		text 		"substitute(centering "centering \scriptsize" Observations "Participants") addnotes("*Distance to nearest town reports distance from regional center where surveys were" "conducted to the nearest county (municipality) seat." "\ddag Income is the reported total of coffee sales, off-farm income, and government subsidies," "excluding income from honey sales.") coeflabels(nearest_town_distance_km "Distance to Nearest Town (km)*" total_ingresos_mil "Income (1,000 MXN)\ddag")"
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	quietly estpost sum $stat_vars if region_honey == 0

	foreach 	y of numlist 		1 2 3 6 8 11  {
	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
}	
	esttab 		using 		"$table_dir/`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear	


********************************************************************************
****			Summary Statistics: Regional Means (honey)	  				****
********************************************************************************

	use 		"$work_dir/encuesta_miel.dta", clear

** 	local 		stat_vars		"age female edu_level family_members dependents coop_member coffee_experience farm_hectares total_coffee_varietals total_types_crops varietals_resistance_perc coffee_harvest total_income total_income_honey total_food_insecurity region_honey_perc"												// (Manual) // Enter variables that are to be measured.

	local 		region 			" "4" "5" "7" "9" "10" " 
	
	local 		label 		"table_summary_stats_honey"
	
	local 		title		"title("Summary Statistics by Region (Honey Regions)" "\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		" mtitles("Overall" `region' )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" quintal "\textbf{Outcome Variables:}", nolabel)"	

	local 		text 		"substitute(centering "centering \scriptsize" Observations "Participants") addnotes("*Distance to nearest town reports distance from regional center where surveys were" "conducted to the nearest county (municipality) seat." "\ddag Income is the reported total of coffee sales, off-farm income, and government subsidies," "excluding income from honey sales.") coeflabels(nearest_town_distance_km "Distance to Nearest Town (km)*" total_ingresos_mil "Income (1,000 MXN)\ddag")"
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	quietly estpost sum $stat_vars if region_honey

	foreach 	y of numlist 		4 5 7 9 10  {
	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
}	
	esttab 		using 		"$table_dir/`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear		


********************************************************************************
****       Summary Stats: Honey regions vs. Non-Honey regions				****
****	  					                                				****
********************************************************************************

	use 		"$work_dir/encuesta_miel.dta", clear

	local 		label 		"table_summary_regional"

	local 		title		"title("Summary Statistics: Honey Regions\dag  vs. Non-Honey"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2"
//																											 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Region\dag}" "\textbf{Non-Honey Region}" "\textbf{Difference}") " // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
	local  		groups 		"refcat(edad "\textbf{Demographics:}" quintal "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" Observations "Participants") coeflabels(nearest_town_distance_km "Distance to Nearest Town (km)*" total_ingresos_mil "Income (1,000 MXN)\ddag")"
	
	local 		notes 		"addnotes("*Distance to nearest town reports distance from regional center where surveys were conducted to" "the nearest county (municipality) seat." "\dag Survey regions \textgreater 20\% honey producer representation are categorized as a honey region." "\ddag Income is the reported total of coffee sales, off-farm income, and government subsidies," "excluding income from honey sales.")" 
	
	
	local 		stat_vars 	" edad female edu_middle_school edu_high_school miembros dependents community_altitude_meters nearest_town_distance_km tiempo_cultivando hectareas quintal total_ingresos_mil total_hambre "

	
	local 		locals		" `title' `columns' `groups' `text' `notes' "        						// Compiles macros together.

	gen 		reverse_honey_region = 0
	replace 	reverse_honey_region = 1 	if region_honey == 0
	
	eststo 		clear
	eststo: 	estpost sum 	`stat_vars' 		if region_honey == 1
	eststo: 	estpost sum 	`stat_vars' 		if region_honey == 0	
	eststo: 	estpost ttest 	`stat_vars' 		, by(reverse_honey_region) unequal

	esttab 		using 		"$table_dir/`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	
	
	
	
********************************************************************************
****       Summary Stats: Honey producers vs. Non-Honey producers			****
****	  					                                				****
********************************************************************************
	use 		"$work_dir/encuesta_miel.dta", clear

	local 		label 		"table_summary_honey"

	local 		title		"title("Summary Statistics: Honey Producers vs. Non-Honey"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2"
//																											 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 
	
	local  		groups 		"refcat(edad "\textbf{Demographics:}" quintal "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" Observations "Participants") coeflabels(nearest_town_distance_km "Distance to Nearest Town (km)*" total_ingresos_mil "Income (1,000 MXN)\ddag")"
	
	local 		notes 		"addnotes("*Distance to nearest town reports distance from regional center where surveys were conducted to" "the nearest county (municipality) seat." "\ddag Income is the reported total of coffee sales, off-farm income, and government subsidies," "excluding income from honey sales.")" 
	
	local 		stat_vars 	" edad female edu_middle_school edu_high_school miembros dependents community_altitude_meters nearest_town_distance_km tiempo_cultivando hectareas quintal total_ingresos_mil total_hambre "

	
	local 		locals		" `title' `columns' `groups' `text' `notes' "        						// Compiles macros together.

	gen 		reverse_miel_produce = 0
	replace 	reverse_miel_produce = 1 	if $balance_sample == 0
	
	eststo 		clear
	eststo: 	estpost sum 	`stat_vars' 		if $balance_sample == 1
	eststo: 	estpost sum 	`stat_vars' 		if $balance_sample == 0	
	eststo: 	estpost ttest 	`stat_vars' 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir/`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 

