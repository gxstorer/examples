clear

**ssc install schemepack
**ssc install estout

set scheme cblind1


********************************************************************************
****                                                                        ****
****                        	 Get data                                   ****
****                                                                        ****
********************************************************************************

	sysuse 		auto, 		clear
	
	split 		make, 		gen(make_)
	encode 		make_1, 	gen(brand)
	replace 	make_2 	= 	make_2 + make_3
	drop 		make_3
	encode 		make_2, 	gen(model)
	
********************************************************************************
****                                                                        ****
****                         Make Figures                                   ****
****                                                                        ****
********************************************************************************

	graph 		bar 		price,       over(rep78) over(foreign) legend(off) asyvar showyvars

	  
********************************************************************************
****                                                                        ****
****                          Make Tables                                   ****
****                                                                        ****
********************************************************************************

    global 		stat_format 	"replace booktabs label gaps nonum noobs"				// (Optional) For summary statistic tables.
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                           	"label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.	
	global 		stat_cells		"cells("mean(fmt(%7.1f)) sd(fmt(%7.1f))")" // (Optional)  Default format is 7 digit max, with 2 decimal points. 
//                                                                              					To change decimal point, change the "2" value to desired decimal point number.
// 																									Collabels removes the statistic label from each column.	
	
	local 		label 		"replace_me"
	
	local 		title		"title("Car prices: Domestic vs. Foreign""\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		"collabels("Mean" "SD")" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	
	local 		locals		" `title' `columns' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	estpost tabstat price, by(foreign) statistics(mean sd) nototal

	
	esttab 		, label gaps nonum noobs cells("mean(fmt(%7.1f)) sd(fmt(%7.1f))") ///
				title("Car prices: Domestic vs. Foreign") collabels("Mean" "SD") // Preview table in STATA	
	esttab 		, $stat_format $stat_cells `locals' 							 // Display LaTeX output of table.
	
	
	eststo 		clear	
	

