********************************************************************************
****						 Food Insecurity	 							****
****						 	 			                        		****
********************************************************************************

	use 					"$work_dir/honey_panel_english.dta"		, clear

	local 		label 		"month_insecurity"

	local 		title		"title("Monthly Variation in Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{Baseline}  " "\textbf{Household FE}" " \textbf{Demographic Controls}") "   						// (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								 	Remove all string except for "" if not used.
	//																							 	(NOTE) Removes dependent variable displayed. 
 		//																							May need to add note or use different command.	
	local 		months 		"2.month "February" 3.month "March" 4.month "April" 5.month "May" 6.month "June" 7.month "July" 8.month "August" 9.month "September" 10.month "October" 11.month "November" 12.month "December" "
	local 		edu 		" 2.edu_level "Secondary Edu." 3.edu_level "High School Edu." "
	local 		cells 		"collabels("Food Insecurity" "SE")"
	local 		coef		"coeflabels( `months' `edu' _cons "Constant" ) wide nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local  		groups 		"refcat(2.month "\textbf{Months:}" female "\textbf{Controls:}", nolabel)"	
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c})"	// (Optional) r2=include r2 in footer. substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"scalars("FE Household fixed effects")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `groups' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity i.month					, $regression
	estadd		local 	FE		"NO"
	eststo:		reghdfe food_insecurity i.month					, $regression absorb(id)
	estadd 		local 	FE 		"YES"
	eststo: 	reg 	food_insecurity i.month female age i.edu_level family_members dependents coop_member coffee_experience , $regression
	estadd		local 	FE 		"NO"
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear