clear

set scheme cblind1
********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

* Set Project Folder Paths *****************************************************

	local 		project 		"file_write_method"						// (NOTE) Only required for project owner	
	
	global 		table_dir 		"outputs/tables" 								// Path to tables produced for project
	global 		figure_dir		"outputs/figures"                               // Path to any graphs or images produced for project

* Set Current Directory	******************************************************** 

	if 		"`c(username)'" != "grants" { 	  	// (NOTE) 	Only Required for external users.
				cd "X"															// (Required) // Replace "X" with directory path to project folder. Make sure project has all three folders above.
}	

	if 		"`c(username)'" == "grants" {
				cd "C:/Users/grants/OneDrive - Inter-American Development Bank Group/Documents/GitHub/examples/LaTeX/Direct from STATA LaTeX/`project'/"
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
****                         Make Figure                                    ****
****                                                                        ****
********************************************************************************

	graph 		bar 		price,       over(rep78) over(foreign) title("Domestic vs. Foreign, by number of repairs") legend(off) asyvar showyvars

	foreach 	y in 		png eps pdf {
	graph 		export 		outputs/figures/`y'/graph_repair_prices.`y'		, as(`y') name("Graph") replace	
	}
	  
********************************************************************************
****                                                                        ****
****                          Make Tables                                    ****
****                                                                        ****
********************************************************************************
	 
	tabstat price, by(foreign) statistics(mean sd) nototal save
	return list
	
* Table 1 (Simple Table)  ******************************************************


	file open table_1 using "outputs/tables/table_1.tex", write replace
	
	file write table_1 									   /// ** preamble
"\begin{table}[htbp]\centering" 									_n ///
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 						_n ///
"\begin{tabular} {l*{1}{cc}}" 										_n 

	file write table_1 										/// ** body
" & " %9.3f (r(Stat1)[1,1]) " & " %9.3f (r(Stat1)[2,1]) "\\" 		_n ///
" & " %9.3f (r(Stat2)[1,1]) " & " %9.3f (r(Stat2)[2,1]) "\\" 		_n 

	file write table_1 									   /// ** footer
"\end{tabular}" 													_n ///
"\end{table}"

	file close table_1	

*  Table 2 (Row/Col names) *****************************************************

	file open table_2 using "outputs/tables/table_2.tex", write replace
	
	file write table_2 												   /// ** preamble
"\begin{table}[htbp]\centering" 												_n ///
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 									_n ///
"\begin{tabular} {l*{1}{cc}}" 													_n 

	file write table_2 												   /// ** body
"&\multicolumn{2}{c}{}     \\"  												_n /// ** Adding format for table header
"& Mean & SD 				\\" 												_n /// ** Adding column names
(r(name1)) " & " %9.3f (r(Stat1)[1,1]) " & " %9.3f (r(Stat1)[2,1]) "\\" 		_n /// ** (r(name1)) adds variable names
(r(name2)) " & " %9.3f (r(Stat2)[1,1]) " & " %9.3f (r(Stat2)[2,1]) "\\" 		_n 

	file write table_2						   						   /// ** footer
"\end{tabular}" 																_n ///
"\end{table}"

	file close table_2	


*  Table 3 (Titles & Notes) ****************************************************

	file open table_3 using "outputs/tables/table_3.tex", write replace
	
	file write table_3 												   /// ** preamble
"\begin{table}[htbp]\centering" 												_n ///
"\caption{Car prices: Domestic vs. Foreign}"									_n /// ** Adding table title
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 									_n ///
"\begin{tabular} {l*{1}{cc}}" 													_n 

	file write table_3 												   /// ** body
"\toprule "																		_n /// ** Adding line below title
"&\multicolumn{2}{c}{}     	\\"  												_n ///
"& Mean & SD				\\" 												_n /// 
"\midrule" 																		_n /// ** Adding line below column names
(r(name1)) " & " %9.3f (r(Stat1)[1,1]) " & " %9.3f  (r(Stat1)[2,1]) "\\" 		_n /// 
(r(name2)) " & " %9.3f (r(Stat2)[1,1]) " & " %9.3f  (r(Stat2)[2,1]) "\\" 		_n 

	file write table_3 													/// ** footer
"\bottomrule"																	_n  /// ** Adding line at after final row of table 
"\multicolumn{3}{l}{\footnotesize Prices in USD.} \\" 							_n  /// ** Adding table footnote 
"\end{tabular}" 																_n  ///
"\end{table}"

	file close table_3	
	
*  Table 4 (Long footnote) *****************************************************

	file open table_4 using "outputs/tables/table_4.tex", write replace
	
	file write table_4 												   /// ** preamble
"\begin{table}[htbp]\centering" 												_n ///
"\caption{Car prices: Domestic vs. Foreign}"									_n /// 
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 									_n ///
"\begin{tabular} {l*{1}{cc}}" 													_n 

	file write table_4 												   /// ** body
"\toprule "																		_n /// 
"&\multicolumn{2}{c}{}     	\\"  												_n ///
"& Mean & SD				\\" 												_n /// 
"\midrule" 																		_n /// 
(r(name1)) " & " %9.3f (r(Stat1)[1,1]) " & " %9.3f  (r(Stat1)[2,1]) "\\" 		_n /// 
(r(name2)) " & " %9.3f (r(Stat2)[1,1]) " & " %9.3f  (r(Stat2)[2,1]) "\\" 		_n 

	file write table_4 													/// ** footer
"\bottomrule"																	_n  /// 
"\multicolumn{3}{p{4.5in}}{\footnotesize Prices in USD. This is a test to see what happens when I write a very lengthy footnote without any breaks. Does it stretch out beyond the table, or does it wrap down to a new row?} \\" 							_n  /// ** Adding lengthy table footnote 
"\end{tabular}" 																_n  ///
"\end{table}"

	file close table_4	

*  Table 5 (threepart table method footnote) ***********************************************

	file open table_5 using "outputs/tables/table_5.tex", write replace
	
	file write table_5 												   /// ** preamble
"\begin{table}[htbp]\centering" 												_n ///
"\begin{threeparttable}"														_n /// ** Add threeparttable environment
"\caption{Car prices: Domestic vs. Foreign}"									_n /// 
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" 									_n ///
"\begin{tabular} {l*{1}{cc}}" 													_n 

	file write table_5 												   /// ** body
"\toprule "																		_n /// 
"&\multicolumn{2}{c}{}     	\\"  												_n ///
"& Mean & SD				\\" 												_n /// 
"\midrule" 																		_n /// 
(r(name1)) " & " %9.3f (r(Stat1)[1,1]) " & " %9.3f  (r(Stat1)[2,1]) "\\" 		_n /// 
(r(name2)) " & " %9.3f (r(Stat2)[1,1]) " & " %9.3f  (r(Stat2)[2,1]) "\\" 		_n 

	file write table_5 													/// ** footer
"\bottomrule"																	_n  /// 
"\end{tabular}" 																_n  ///
"\begin{tablenotes}[flushleft]"													_n  /// ** Add footnote environment. [flushleft] makes footnote left-aligned. 
"\item Prices in USD. This is a test to see what happens when I write a very lengthy footnote without any breaks. Does it stretch out beyond the table, or does it wrap down to a new row?" _n /// ** Begin with "\item". If you want to number the footnote, put "[1]" prior to footnote.
"\end{tablenotes}" 																_n  /// ** End footnote environment
"\end{threeparttable}"															_n  /// ** End threeparttable environment
"\end{table}"

	file close table_5	

// This method is useful if you don't want to deal with any manual fixing of table spacing, and just want to throw in footnotes that will fall in line with the rest of the table.
// Note, main .tex document must call up package: "\usepackage{threeparttable}" in preamble.

