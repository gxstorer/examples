clear

********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

	set scheme cblind1

* Set Project Folder Paths *****************************************************

	local 		project 		"Chiapas-Honey-Paper"							// (NOTE) Only required for Razvan and Grant	
																				// (Required) // replace "X" with project folder name
	
	global 		data_dir 		"data/original_data" 	 						// Path to source data
	global 		work_dir 		"data/working_data" 							// Path to any produced data files within project
	global		code_dir        "data/code"
	global 		table_dir 		"project/tables" 								// Path to tables produced for project
	global 		figure_dir		"project/figures"                               // Path to any graphs or images produced for project

* Set Current Directory	******************************************************** 

	if 		"`c(username)'" != "GRANTS" & "`c(username)'" != "grantstorer" { 	  									// (NOTE) 	Only Required for external users.
				cd "X"															// (Required) // Replace "X" with directory path to project folder. Make sure project has all three folders above.
}	

	if 		"`c(username)'" == "GRANTS" {
				cd "C:\Users\grants\OneDrive - Inter-American Development Bank Group\Documents\GitHub\\`project'\"
} 																				// Will set current directory to Grant's path if username is listed as "GRANTS"
	if 		"`c(username)'" == "grantstorer" {
				cd "/Users/grantstorer/Documents/GitHub/`project'/"
} 	


* Set General Output Formats *************************************************** // Set of commands that will be applied to entire project. 
//                                                                                  Put whatever you want to be applied within specified output category.
	
	global  	text 			"\small"	    								// (Optional) Setting the text size of tables. Needs to be included into 
//                                                                              // the substitute() command in order to work. See locals for example.
	global 		stars			"star(* .10 ** .05 *** .01)"					// (Optional) To change, order within goes: (symbol) (value) ...
	
	global 		balance_format 	"replace booktabs label compress gaps"			// (Optional) For balance testing tables.   
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                              "label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.		
	global 		balance_cells	"cells("mean(pattern(1 1 0) fmt(%7.2f) label(Mean)) sd(pattern(1 1 0) fmt(%7.2f) label(Std. Dev.)) b(star pattern(0 0 1) fmt(%7.2f) label(Mean)) t(pattern(0 0 1) par fmt(%7.2f) label(T-Stat))") "          
																				// (Optional) Table default will display mean & sd for the two samples that are being compared, with the 3rd model being the difference between samples. 
// 																				   pattern() determines if given stat is to be displayed in a particular model.
//                 																   label()   manually labels each column.
//                                                                                 fmt()     formats cells to 2 decimal points.	
	global 		balance_sample 	"miel_produce" 									
    global 		stat_format 	"replace booktabs label compress"				// (Optional) For summary statistic tables.
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                           	"label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.	
	global 		stat_cells		"gaps nonum collabels(none) cells(mean(fmt(%7.1f)))" // (Optional)  Default format is 7 digit max, with 2 decimal points. 
//                                                                              					To change decimal point, change the "2" value to desired decimal point number.
// 																									Collabels removes the statistic label from each column.	
	global 		stat_vars 		" edad female edu_middle_school edu_high_school miembros dependents community_altitude_meters nearest_town_distance_km tiempo_cultivando hectareas quintal total_ingresos_mil  total_hambre region_honey_perc "
																				// (Manual) // Variables used in summary statistics
		
 	global 		stat_sample		"region_survey" 							    // (Manual) // Enter variable of sample population that you want to compare.

	global 		reg_format   	"replace booktabs label"        				// (Optional) For regression output tables. Same as previous format macros.
	
	global 		reg_cells		" edad female i.edu_level miembros dependents i.region_survey tiempo_cultivando hectareas quintal total_ingresos_mil "
	
	global 		reg_decimal 	"b(2) se(2)"									// (Optional) Typically, 2 decimal points is preferred.
	
	global 		graph_twoway 	"  " // Graph format for twoway graphs.
	
	global 		graph_hist  	" " // Graph format for histogram graphs.
	
	global 		graph_export 	"name("Graph") replace "  // Exporting format for all graphs.
	
	global 		regression 		"vce(cluster id) " 								// (Optional) If using a specific kind of Standard Error, or other after 
//                                                                              comma commands that will be repeated in all regressions, place here.


********************************************************************************
****						  				  								****
****							  DATA CLEANING	  							****
****						  				  								****
********************************************************************************

* Data cleaning & Spanish survey data ******************************************
	do 			"$code_dir/chiapas_honey_data_cleaning.do"
	
* Panel Data (Spanish) *********************************************************

	do 			"$code_dir/chiapas_honey_panel_data.do"

* Panel Data (English) *********************************************************

	do 			"$code_dir/chiapas_honey_english.do"


********************************************************************************
****						  				  								****
****							  Estimation	  							****
****						  				  								****
********************************************************************************

* Summary stats ****************************************************************

	do 			"$code_dir/chiapas_honey_tables_summary_stats.do"
	
* Seasonality Figures **********************************************************

	do 			"$code_dir/chiapas_honey_figures_monthly.do"	
	
* Food Insecurity by month table ***********************************************

	do 			"$code_dir/chiapas_honey_table_food_insecurity.do"
	
* OLS Diff-in-diff *************************************************************

	do 			"$code_dir/chiapas_honey_DID.do"
	
* 2SLS *************************************************************************

	do 			"$code_dir/chiapas_honey_2SLS.do"
	
* Robustness check: 2SLS - Lean Season *****************************************

	do 			"$code_dir/chiapas_honey_2SLS_lean.do"
	
* Honey Region Share Figures ***************************************************

	do 			"$code_dir/chiapas_honey_figures_honey_regions.do"
	
* Types of income Figures ******************************************************

	do 			"$code_dir/chiapas_honey_figures_income.do"
	
