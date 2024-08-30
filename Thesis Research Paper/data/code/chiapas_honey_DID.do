********************************************************************************
****							  Table (6):	 	 						****
****						 	 Diff-in-Diff	 	 						****
********************************************************************************
	use 			"$work_dir/honey_panel_english.dta"	, clear		

	local 		label 		"table_DiD"

	local 		title		"title("Effect of Honey Production in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{Baseline}  " "\textbf{Household FE}" " \textbf{All Controls}") "   						
	local 		cells 		"collabels("Food Insecurity\textsuperscript{1}" "SE") keep(1.honey_producer#1.month_honey 1.honey_producer 1.month_honey _cons)"
	local 		coef		"coeflabels( 1.honey_producer#1.month_honey "Honey Producer x Honey Season\textsuperscript{2}" 1.honey_producer "Honey Producer" 1.month_honey "Honey Season\textsuperscript{2}" _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		" substitute("centering" "centering \small" "Standard" "`SE' standard" "0.00         &        0.02" " (.)         &        0.02" "(.)" " ") "	// (Optional) substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"r2 noobs scalars("Obs Observations" "Subjects Participants" "Months Months" "r2 R\textsuperscript{2}" "FE \hline Household Fixed Effects" "Regional Regional Controls" "Demo Demographic Controls\textsuperscript{3}")"
	
	local 		notes		" addnotes("1. The dependent variable is a dummy which equals 1 if the producer reports food insecurity in a" "given month, 0 otherwise." "2. Honey Season is a dummy which equals 1 if the observed month is either March, April, May" "or June, 0 for all other months." "3. Demographic Controls: Age, Gender, Education Level, Household Size, Dependents," "Coffee Experience, Farm Size, Coffee Harvest, Income.")"
	
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `notes' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey				, $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE			"NO"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 		"3,300"	
	
	eststo:		reghdfe food_insecurity 	honey_producer##month_honey					, $regression absorb(id)
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd 		local 	FE 			"YES"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 	 	"3,300"	
	
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey female age i.edu_level family_members dependents i.region_survey coffee_experience farm_hectares quintal total_income , $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE 			"NO" 
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"YES"
	estadd 		local 	Obs 	 	"3,300"	
	
	esttab 		using  		"$table_dir/`label'", $stars $reg_format `locals'
	eststo clear
	