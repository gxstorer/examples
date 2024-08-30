clear

********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

* Set Project Folder Paths *****************************************************

	local 		project 		"X"												// (NOTE) Only required for Razvan and Grant	
																				// (Required) // replace "X" with project folder name
	
	local 		data_dir 		"data\original_data\" 	 						// Path to source data
	local 		work_dir 		"data\working_data\" 							// Path to any produced data files within project
	local 		table_dir 		"project\tables\" 								// Path to tables produced for project
	local 		figure_dir		"project\figures\"                              // Path to any graphs or images produced for project

* Set Current Directory	******************************************************** 

	if 		"`c(username)'" != "vlaicu" & "`c(username)'" != "GRANTS" { 	  	// (NOTE) 	Only Required for external users.
				cd "X"															// (Required) // Replace "X" with directory path to project folder. Make sure project has all three folders above.
}	

	if 		"`c(username)'" == "GRANTS" {
				cd "C:\Users\grants\OneDrive - Inter-American Development Bank Group\VlaicuShared\GStorerShared\1.Projects\\`project'\"
} 																				// Will set current directory to Grant's path if username is listed as "GRANTS"

	if 		"`c(username)'" == "vlaicu" {
				cd "C:\Users\vlaicu\OneDrive - Inter-American Development Bank Group\VlaicuShared\GStorerShared\1.Projects\\`project'\"
} 																				// Will set current directory to Razvan's path if username is listed as "VLAICU"	

* Set General Output Formats *************************************************** // Set of commands that will be applied to entire project. 
//                                                                                  Put whatever you want to be applied within specified output category.
	
	global  	text 			"\small"	    								// (Optional) Setting the text size of tables. Needs to be included into 
//                                                                              // the substitute() command in order to work. See locals for example.
	global 		stars			"star(* .10 ** .05 *** .01)"					// (Optional) To change, order within goes: (symbol) (value) ...
	
	global 		balance_format 	"replace booktabs label compress nogaps"		// (Optional) For balance testing tables.   
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                              "label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.		
	global 		balance_cells	"cells("mean(pattern(1 1 0) fmt(%7.2f) label(Mean)) sd(pattern(1 1 0) fmt(%7.2f) label(Std. Dev.)) b(star pattern(0 0 1) fmt(%7.2f) label(Mean)) t(pattern(0 0 1) par fmt(%7.2f) label(T-Stat))") "           // (Optional) Table default will display mean & sd for the two samples that
//                                                                              are being compared, with the 3rd model being the difference between samples. 
// 																				   pattern() determines if given stat is to be displayed in a particular model.
//                 																   label()   manually labels each column.
//                                                                                 fmt()     formats cells to 2 decimal points.	
    global 		stat_format 	"replace booktabs label compress"				// (Optional) For summary statistic tables.
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                           	"label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.	
	global 		stat_cells		"nogaps collabels(none) cells(mean(fmt(%7.1f)))"// (Optional)  Default format is 7 digit max, with 2 decimal points. 
//                                                                              To change decimal point, change the "2" value to desired decimal point number.
// 																				Collabels removes the statistic label from each column.	
	global 		stat_vars 		" "                                             // (Manual) // Variables used in summary statistics
	
	global 		stat_sample		" " 								            // (Manual) // Enter variable of sample population that you want to compare.

	global 		reg_format   	"replace booktabs compress nogaps label"        // (Optional) For regression output tables. Same as previous format macros.
	
	global 		reg_cells		" "
	
	global 		reg_decimal 	"b(2) se(2)"									// (Optional) Typically, 2 decimal points is preferred.
	
	global 		graph_twoway 	" graphregion(fcolor(navy%12)) plotregion(fcol(forest_green%12)) " // Graph format for twoway graphs.
	
	global 		graph_hist  	" graphregion(fcolor(navy%12)) plotregion(fcol(forest_green%12)) " // Graph format for histogram graphs.
	
	global 		graph_export 	" as(jpg) quality(100) name("Graph") replace "  // Exporting format for all graphs.
	
	global 		regression 		" " 											// (Optional) If using a specific kind of Standard Error, or other after 
//                                                                              comma commands that will be repeated in all regressions, place here.


********************************************************************************
****                                                                        ****
****                              Local Macros                              ****
****                                                                        ****
********************************************************************************
/*
* Summary Statistics Template **************************************************
	local 		label 		"table_summary"                                     // (Manual) // Enter desired file name. Also used as ref label in LaTeX.
	
	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.	
	local 		columns		"mtitles("Name1" "Name2" )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
	
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 
	local   	text 	    "substitute(centering "centering $text " )"	        // (Optional) Setting balance tables text size, using text size macro.
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.

	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 	
	
	esttab 		using 		"$table_dir\`label'", $stat_format $stat_cells `locals' 
		
	eststo clear		
	
* Balance Testing Template *****************************************************

	local 		label 		"table_balance" 									// (Manual) // Enter desired file name. Also used as ref label in LaTeX.

	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.
	local 		columns		"mtitles("\textbf{Treatment}" "\textbf{Control}" "\textbf{Difference}") " 		
//                                                                              // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																				Remove all string except for "" if not used. 
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 
	local   	text 	    "substitute(centering "centering $text " )"	        // (Optional) Setting balance tables text size, using text size macro.
	
	local 		locals		" `title' `columns' `groups' `text' "        		// Compiles macros together.

	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if $stat_sample == 0         
	eststo: 	estpost sum 	$stat_vars 		if $stat_sample == 1	
	eststo: 	estpost ttest 	$stat_vars 		, by($stat_sample ) unequal 
	
	esttab 		using 		"$table_dir\`label'", $stars $balance_format $balance_cells `locals' 
	eststo 		clear 
	
* Regression Table Template ****************************************************  // Set to default format, with options to customize.

	local 		label 		"reg_" 									            // (Manual) // Enter desired file name. Also used as ref label in LaTeX.

	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.
	local 		columns		"mtitles("\textbf{Name1}" "\textbf{Name2}" ) " 	    // (Manual) // Used to label models.
//                                                                              Customize table columns by order L-R : "Name1" "Name2" ...
// 																				Remove all string except for "" if not used. 
	local 		cells 		"collabels("dependent_var")"                        // (Manual) // When using `columns', this command allows you to label the 
//                                                                              dependent variable that the coefficients are being compared to. 
	local 		coef		"coeflabels( _cons "Constant" )"					// (Optional) Customize coefficients: (var) "New Name" ...
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 

	local 		SE			" "													// (Optional) If using other kind of SE, 
//                                                                                 Enter term you want listed that precedes the word "Standard Errors."
	local 		footer 		"r2 substitute(Standard "`SE' standard" {l} {c})"	// (Optional) r2=include r2 in footer. 
//                                                                              substitute() enters what was in SE local, but also 
//                                                                              manually reformats footer to be centered.
//																				(NOTE) could potentially affect other elements, since any 
// 																				left-aligned cells will be centered.
   
    local 		scalar 		"scalars("e_name label")" 							// If you want to add additional footer content,
// 																				enter scalar name/e(name), followed by what you want to label this scalar.
	
	local 		locals 		"`title' `columns' `cells' `coef' `groups' `footer' `scalar' " // Compiles all locals together. 
	
	eststo clear
	eststo: 	reg 	dependent_var 	independent_var	control_var1			, $regression // example format of regression. 
	estadd		local 	FE		"NO"                                            // Manually adding a scalar 

	esttab 		using  		"$table_dir\`label'", $reg_format $reg_cells $reg_decimal `locals' 
	eststo clear
	
	
* Twoway Graph Template  *******************************************************

	local 		legend	 	"legend(order() span size(small) color(white))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles		"title() xtitle() ytitle()" 						// (Manual) // Axis titles. Remove if n/a. 
	local 		xline		"xline(0.5, lcol(stone) lwidth(medthick))"		 	// (Manual) // Placement on x-axis, followed by color and thickness.
// 																								  Remove all string except for "" if not used.			
	local 		locals 		"`legend' `titles' `xline'" 						// (Optional) Add any new locals to the command 
	
	twoway 		(scatter (Y-Var1) 	(X-Var)  	if (Condition)  ,  	mcolor(edkblue) msymbol(diamond_hollow) msize(2-pt)) ///
				(line 	 (Y-Var2) 	(X-Var)						, 	lcol("187 0 0") lwidth(thick)) ///
				(lfit 	 (Y-Var1) 	(X-Var)  	if (Condition)  ,	lcol(edkblue) lwidth(medthick)) ///
				,  $graph_twoway `locals'
			
	graph 		export 		"$figure_dir\`label'"		, 	$graph_export 

* Bar Graph Template  **********************************************************	

	local 		legend 		"legend(order() span size(small) color(white))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title() xtitle() ytitle()" 						// (Manual) // Axis titles. Remove if n/a. 
	
	local 		locals 		" `legend' 	`titles' "
	
	graph 		bar (Y-Var1) (Y-Var2) (Y-Var3), over("X-Var") /// 
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) bar(3,color("187 0 0")) /// 
				$graph_hist `locals'
				
	graph 		export 		"$figure_dir\`label'"		, 	$graph_export 
	
*/	
********************************************************************************
****						  				  								****
****							  DATA CLEANING	  							****
****						  				  								****
********************************************************************************




********************************************************************************
****						  				  								****
****						  Balance Testing	  							****
****						  				  								****
********************************************************************************
	

	
********************************************************************************
****						  				  								****
****							  Estimation	  							****
****						  				  								****
********************************************************************************


