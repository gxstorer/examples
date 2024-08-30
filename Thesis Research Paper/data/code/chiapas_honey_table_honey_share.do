********************************************************************************
****							  table (7):	 	 						****
****						 2SLS Diff-in-Diff		 	 					****
********************************************************************************

	use 				"$work_dir/encuesta_miel.dta", clear
	
************     Model (6): Honey producers during honey harvest, with individual fixed effects     **************

	local 		label 		"table_IV"

	local 		title		"title("Effect of Regional Honey Producer Share on Producer Status"\label{`label'})"				
																				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	" "   						
	local 		cells 		"collabels("Honey Producer\textsuperscript{1}") nomtitles nonum gap"
	local 		coef		"coeflabels(region_honey_share "Share of Honey Producers In Region\textsuperscript{2}" _cons "Constant" ) nobaselevels"										  // (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.

	local 		footer 		"substitute(centering "centering \small") "	
																				// (Optional) r2=include r2 in footer. substitute() enters what was in SE

    local 		scalar 		"r2 noobs scalars("F F-Statistic" "Obs Observations")"
	local 		notes		" addnotes("\textbf{1.} Dependent variable is a dummy which equals 1 if the participant is a honey producer, 0 if otherwise." "\textbf{2.} Independent variable is the share of participants in the same region that are honey producers," "excluding the participant themselves." )"
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `notes' " // Compiles all globals together. 
	
	
***********     Model (7): First Stage 2SLS Regression 	   *******************			

	rename 	miel_produce honey_producer

	eststo 		clear
	eststo:		reg 	honey_producer region_honey_share 
	estadd 		local 	Obs 	 "275"
	
	esttab 		using  		"$table_dir/`label'"	, $stars $reg_format `locals' 
	eststo clear							 
