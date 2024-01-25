clear

set scheme cblind1
********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

* Set Project Folder Paths *****************************************************

	local 		project 		"paper_template"							// (NOTE) Only required for project owner	
	
	global 		table_dir 		"outputs\tables\" 								// Path to tables produced for project
	global 		figure_dir		"outputs\figures\"                              // Path to any graphs or images produced for project

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
	graph 		export 		$figure_dir\\`y'\\project_name_figure_name.`y'		, as(`y') name("Graph") replace	
	}
	  
********************************************************************************
****                                                                        ****
****                          Make Tables                                   ****
****                                                                        ****
********************************************************************************
	 
	tabstat price, by(foreign) statistics(mean sd) nototal save
	return list
	
* Table 1 (Simple Table)  ************************************************project_name_table_name
	file open project_name_table_name using "outputs\tables\project_name_table_name.tex", write replace
	
	file write project_name_table_name 												   /// ** preamble
"\begin{table}[htbp]\centering" 												_n ///
"\begin{threeparttable}"														_n /// ** Add threeparttable environment
"\caption{Car prices: Domestic vs. Foreign}"									_n /// 
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 									_n ///
"\begin{tabular} {l*{1}{cc}}" 													_n 

	file write project_name_table_name 												   /// ** body
"\toprule "																		_n /// 
"&\multicolumn{2}{c}{}     	\\"  												_n ///
"& Mean & SD				\\" 												_n /// 
"\midrule" 																		_n /// 
(r(name1)) " & " %9.3f (r(Stat1)[1,1]) " & " %9.3f  (r(Stat1)[2,1]) "\\" 		_n /// 
(r(name2)) " & " %9.3f (r(Stat2)[1,1]) " & " %9.3f  (r(Stat2)[2,1]) "\\" 		_n 

	file write project_name_table_name 													/// ** footer
"\bottomrule"																	_n  /// 
"\end{tabular}" 																_n  ///
"\begin{tablenotes}[flushleft]"													_n  /// ** Add footnote environment. [flushleft] makes footnote left-aligned. 
"\item Prices in USD. This is a test to see what happens when I write a very lengthy footnote without any breaks. Does it stretch out beyond the table, or does it wrap down to a new row?" _n /// ** Begin with "\item". If you want to number the footnote, put "[1]" prior to footnote.
"\end{tablenotes}" 																_n  /// ** End footnote environment
"\end{threeparttable}"															_n  /// ** End threeparttable environment
"\end{table}"

	file close project_name_table_name	

// This method is useful if you don't want to deal with any manual fixing of table spacing, and just want to throw in footnotes that will fall in line with the rest of the table.
// Note, main .tex document must call up package: "\usepackage{threeparttable}" in preamble.
