********************************************************************************
****							  Table ():	 	 	 						****
****					 	 Total Food Insecurity 	 						****
********************************************************************************
	use 		"$work_dir/encuesta_miel.dta", clear

	local 		label 		"table_total_insecurity"

	local 		title		"title("Effect of Honey Production on Total Months of Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("\shortstack{\underline{OLS}\\ \\ \textbf{Baseline}}" "\shortstack{\underline{OLS}\\ \\ \textbf{Regional Controls}}" "\shortstack{\underline{OLS}\\ \\ \textbf{All Controls}}" "\shortstack{\underline{IV}\\ \\ \textbf{All Controls}}") " 
  						
	local 		cells 		"collabels("Food Insecurity\textsuperscript{1}" "SE") keep(miel_produce _cons)"
	local 		coef		"coeflabels( miel_produce "Honey Producer"  _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Robust"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"substitute(centering "centering \small" "Standard" "`SE' standard" "\multicolumn{1}{c}{(4)}\\" "\multicolumn{1}{c}{(4)}\\ \addlinespace")"	// (Optional) r2=include r2 in footer. substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"r2 scalars("Regional \hline Regional Controls" "Demo Demographic Controls\textsuperscript{2}" )"	
	
	local 		notes 		"addnotes("\textbf{1.} Dependent variable is the total number of months that producers reported experiencing food insecurity in" "the past 12 months." "\textbf{2.} Demographic Controls: Age, Gender, Education Level, Household Size, Dependents, Coffee Experience," "Farm Size, Coffee Harvest, Income.")"
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `notes' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	total_hambre miel_produce, robust			
	estadd 		local 	Regional "NO"
	estadd 		local 	Demo "NO"
	
	eststo: 	reg 	total_hambre miel_produce i.region_survey, robust			
	estadd 		local 	Regional "NO"
	estadd 		local 	Demo "YES"	
	
	eststo: 	reg 	total_hambre miel_produce $reg_cells, robust 
	estadd 		local 	Regional "YES"	
	estadd 		local 	Demo "YES"
	
	eststo: 	ivreg2 	total_hambre (miel_produce = region_honey_share)  $reg_cells, robust
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"YES"	
				
	
	esttab 		, $stars $reg_format `locals' 									// Stata preview version of output.
	esttab 		using  		"$table_dir/`label'", $stars $reg_format `locals' 
	eststo clear
