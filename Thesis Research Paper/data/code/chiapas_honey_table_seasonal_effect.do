********************************************************************************
****							  Table (6):	 	 						****
****						 	 Diff-in-Diff	 	 						****
********************************************************************************
	use 			"$work_dir/honey_panel_english.dta"	, clear		

	local 		label 		"table_seasonal_effect"

	local 		title		"title("Effect of Honey Production in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("\shortstack{\underline{OLS}\\ \\ \textbf{Baseline}}" "\shortstack{\underline{OLS}\\ \\ \textbf{All Controls}}" "\shortstack{\underline{OLS}\\ \\ \textbf{Participant FE}}" "\shortstack{\underline{IV}\\ \\ \textbf{Participant FE}}") "   						
	local 		cells 		"collabels("Food Insecurity\textsuperscript{1}" "SE") keep(honey_producer_x_honey_season honey_producer month_honey _cons)"
	local 		coef		"coeflabels(honey_producer_x_honey_season  "Honey Producer x Honey Season\textsuperscript{2}" month_honey "Honey Season\textsuperscript{2}" honey_producer "Honey Producer" _cons "Constant" ) nobaselevels"							// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered\textsuperscript{5}"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		" substitute("centering" "centering \small" "Standard" "`SE' standard" " 0.00         &        0.00 " " Absorbed\textsuperscript{3}         &        Absorbed\textsuperscript{3} " " (.)         &         (.)" "           &           "  "\multicolumn{1}{c}{(4)}\\" "\multicolumn{1}{c}{(4)}\\ \addlinespace" ) "	// (Optional) substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"r2 noobs scalars("Obs Observations" "Subjects Participants" "Months Months" "r2 R\textsuperscript{2}" "FE \hline Participant Fixed Effects" "Regional Regional Controls" "Demo Demographic Controls\textsuperscript{4}")"
	
	local 		notes		" addnotes("\textbf{1.} Dependent variable is a dummy which equals 1 if the producer reports food insecurity in a given month, 0 otherwise." "\textbf{2.} Honey Season is a dummy which equals 1 if the observed month is between April-June, 0 for all other months." "\textbf{3.} Honey producer status is a participant level characteristic, therefore it is absorbed into the participant fixed effects." "\textbf{4.} Demographic Controls: Age, Gender, Education Level, Household Size, Dependents, Coffee Experience, Farm Size," "Coffee Harvest, Income." "\textbf{5.} Standard errors are clustered at the participant level.")"
	
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `notes' " // Compiles all globals together. 

** Interaction terms for IV	
	gen 	honey_producer_x_honey_season 	= 	honey_producer 		* 	month_honey
	gen 	iv_share_honey					= 	region_honey_share 	* 	month_honey
	
	
	eststo clear
	eststo: 	reg 	food_insecurity 	honey_producer_x_honey_season 	month_honey 	honey_producer				, $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE			"NO"
	estadd 		local 	Regional 	"NO"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 		"3,300"	

	eststo: 	reg 	food_insecurity 	honey_producer_x_honey_season 	month_honey 	honey_producer female age i.edu_level family_members dependents i.region_survey coffee_experience farm_hectares quintal total_income , $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE 			"NO" 
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"YES"
	estadd 		local 	Obs 	 	"3,300"		
	
	eststo: 	reghdfe 	food_insecurity 	honey_producer_x_honey_season 	month_honey 	honey_producer 	i.region_survey		, $regression  absorb(id)
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd 		local 	FE 			"YES"
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"NO"
	estadd 		local 	Obs 	 	"3,300"	
	
	
***********    Model (8): 2nd Stage 2SLS with IV   ******************				

	eststo: 	xtivreg 	food_insecurity ( ///
													honey_producer_x_honey_season  	honey_producer 		 /// 
												= 	iv_share_honey					region_honey_share 	 /// 
											) ///
													month_honey i.region_survey , fe  $regression
	estadd 		local 	Subjects 	"275"
	estadd		local	Months 		"12"
	estadd		local 	FE 			"YES"
	estadd 		local 	Regional 	"YES"
	estadd 		local 	Demo 		"NO"	
	estadd 		local 	Obs 	 	"3,300"						
	
	esttab 		using  		"$table_dir/`label'", $stars $reg_format `locals'
	eststo clear
	