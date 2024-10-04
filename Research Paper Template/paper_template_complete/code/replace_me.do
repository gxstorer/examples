clear

**ssc install schemepack
**ssc install estout

set scheme cblind1
********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

* Set Project Folder Paths *****************************************************

	local 		project 		"paper_template_complete"						// (NOTE) Only required for project owner	
	
	global 		table_dir 		"outputs/tables" 								// Path to tables produced for project
	global 		figure_dir		"outputs/figures"                              	// Path to any graphs or images produced for project

* Set Current Directory	******************************************************** 

	if 		"`c(username)'" != "GRANTS" { 	  									// (NOTE) 	Only Required for external users.
				cd "X"															// (Required) // Replace "X" with directory path to project folder. Make sure project has all three folders above.
}	

	if 		"`c(username)'" == "GRANTS" {
				cd "C:/Users/grants/OneDrive - Inter-American Development Bank Group/Documents/GitHub/examples/Research Paper Template/`project'/"
} 																				// Will set current directory to Grant's path if username is listed as "GRANTS"

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

	foreach 	y in 		png eps pdf {
	graph 		export 		$figure_dir/`y'/figure_replace_me.`y'		, as(`y') name("Graph") replace // This is a template to produce the figure automatically into three different formats and 
																										// to save them in each of their designated	folders. e.g. pdf format of figure will be saved as filename.pdf in the pdf folder.
	}
	  
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

	esttab 		using 		"$table_dir/table_`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear	
	

