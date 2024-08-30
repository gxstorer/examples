********************************************************************************
****						 Food Insecurity	 							****
****						 	 			                        		****
********************************************************************************

	use 					"$work_dir/honey_panel_english.dta"		, clear

	local 		label 		"table_month_insecurity"

	local 		title		"title("Monthly Variation in Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("\textbf{Baseline}" "\textbf{All Controls}" "\textbf{Participant FE} ")"   						// (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								 	Remove all string except for "" if not used.
	//																							 	(NOTE) Removes dependent variable displayed. 
 		//																							May need to add note or use different command.	
	local 		months 		"2.month "February" 3.month "March" 4.month "April" 5.month "May" 6.month "June" 7.month "July" 8.month "August" 9.month "September" 10.month "October" 11.month "November" 12.month "December" "
	local 		cells 		"collabels("Food Insecurity\textsuperscript{1}" "SE") wide"
	local 		coef		"coeflabels( `months' _cons "Constant\textsuperscript{3}" ) keep(2.month 3.month 4.month 5.month 6.month 7.month 8.month 9.month 10.month 11.month 12.month _cons) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local  		groups 		" "	
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered\textsuperscript{4}"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard")"	// (Optional) r2=include r2 in footer. substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"scalars("Obs Observations" "Subjects Participants" "Months Months" "Regional \hline Regional Controls" "Demo Demographic Controls\textsuperscript{2}" "FE Participant fixed effects")"
	
	local 		notes 		"addnotes("\textbf{1.} Dependent variable is a dummy which equals 1 if the producer reports food insecurity in a given month, 0 otherwise." "\textbf{2.} Demographic Controls: Age, Gender, Education Level, Household Size, Dependents, Coffee Experience, Farm Size," "Coffee Harvest, Income." "\textbf{3.} January is the reference month." "\textbf{4.} The standard errors are clustered at the participant level." )"
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `groups' `notes' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity i.month							, $regression
	estadd		local 	FE			"NO"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"YES"
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd 		local 	Obs 		"3,300"	
	
	eststo: 	reg 	food_insecurity i.month 	female age i.edu_level family_members dependents i.region_survey coffee_experience farm_hectares quintal total_income 			, $regression
	estadd		local 	FE 			"NO"
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"YES"
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"	
	estadd 		local 	Obs 		"3,300"		
	
	eststo:		reghdfe food_insecurity i.month 	i.region_survey		, $regression absorb(id)
	estadd 		local 	FE 			"YES"
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"	
	estadd 		local 	Obs 		"3,300"	
	
	
	esttab 		using  		"$table_dir/`label'", $stars $reg_format `locals' 
	eststo clear
