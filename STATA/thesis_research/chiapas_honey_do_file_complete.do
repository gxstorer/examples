clear

********************************************************************************
****                                                                        ****
****                         Set Macros                                     ****
****                                                                        ****
********************************************************************************

* Set Project Folder Paths *****************************************************

	local 		project 		"Chiapas-Honey-Paper"												// (NOTE) Only required for Razvan and Grant	
																				// (Required) // replace "X" with project folder name
	
	global 		data_dir 		"data\original_data" 	 						// Path to source data
	global 		work_dir 		"data\working_data" 							// Path to any produced data files within project
	global 		table_dir 		"project\tables" 								// Path to tables produced for project
	global 		figure_dir		"project\figures"                              // Path to any graphs or images produced for project

* Set Current Directory	******************************************************** 

	if 		"`c(username)'" != "vlaicu" & "`c(username)'" != "GRANTS" { 	  	// (NOTE) 	Only Required for external users.
				cd "X"															// (Required) // Replace "X" with directory path to project folder. Make sure project has all three folders above.
}	

	if 		"`c(username)'" == "GRANTS" {
				cd "C:\Users\grants\OneDrive - Inter-American Development Bank Group\Documents\GitHub\\`project'\"
} 																				// Will set current directory to Grant's path if username is listed as "GRANTS"

	if 		"`c(username)'" == "vlaicu" {
				cd "C:\Users\vlaicu\OneDrive - Inter-American Development Bank Group\VlaicuShared\GStorerShared\1.Projects\\`project'\"
} 																				// Will set current directory to Razvan's path if username is listed as "VLAICU"	

* Set General Output Formats *************************************************** // Set of commands that will be applied to entire project. 
//                                                                                  Put whatever you want to be applied within specified output category.
	
	global  	text 			"\small"	    								// (Optional) Setting the text size of tables. Needs to be included into 
//                                                                              // the substitute() command in order to work. See locals for example.
	global 		stars			"star(* .10 ** .05 *** .01)"					// (Optional) To change, order within goes: (symbol) (value) ...
	
	global 		balance_format 	"replace booktabs label compress gaps"		// (Optional) For balance testing tables.   
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                              "label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.		
	global 		balance_cells	"cells("mean(pattern(1 1 0) fmt(%7.2f) label(Mean)) sd(pattern(1 1 0) fmt(%7.2f) label(Std. Dev.)) b(star pattern(0 0 1) fmt(%7.2f) label(Mean)) t(pattern(0 0 1) par fmt(%7.2f) label(T-Stat))") "           // (Optional) Table default will display mean & sd for the two samples that
//                                                                              are being compared, with the 3rd model being the difference between samples. 
// 																				   pattern() determines if given stat is to be displayed in a particular model.
//                 																   label()   manually labels each column.
//                                                                                 fmt()     formats cells to 2 decimal points.	
	global 		balance_sample 	"miel_produce" 									
    global 		stat_format 	"replace booktabs label compress"				// (Optional) For summary statistic tables.
//                                                                                          	"replace"/"ammend" = overwrite file, 
//                                                                                           	"label" = use of var labels instad of var names,  
// 																							    "compress" = table width, 
//                                                                                              "nogaps"/"gaps" = table height, 
//                                                                                              "booktabs" = Overleaf LaTeX table format.	
	global 		stat_cells		"gaps nonum collabels(none) cells(mean(fmt(%7.1f)))" // (Optional)  Default format is 7 digit max, with 2 decimal points. 
//                                                                              To change decimal point, change the "2" value to desired decimal point number.
// 																				Collabels removes the statistic label from each column.	
	global 		stat_vars 		" edad female edu_level miembros dependents coop_member tiempo_cultivando hectareas total_cafe_variedades total_cultivos varietals_resistance_perc quintal total_ingresos_mil total_ingresos_miel_mil total_hambre region_honey_perc "
																				// (Manual) // Variables used in summary statistics
		
 	global 		stat_sample		"region_survey" 							    // (Manual) // Enter variable of sample population that you want to compare.

	global 		reg_format   	"replace booktabs compress nogaps label"        // (Optional) For regression output tables. Same as previous format macros.
	
	global 		reg_cells		" "
	
	global 		reg_decimal 	"b(2) se(2)"									// (Optional) Typically, 2 decimal points is preferred.
	
	global 		graph_twoway 	"  " // Graph format for twoway graphs.
	
	global 		graph_hist  	" " // Graph format for histogram graphs.
	
	global 		graph_export 	" as(png) name("Graph") replace "  // Exporting format for all graphs.
	
	global 		regression 		"vce(cluster id) " 											// (Optional) If using a specific kind of Standard Error, or other after 
//                                                                              comma commands that will be repeated in all regressions, place here.


********************************************************************************
****                                                                        ****
****                              Local Macros                              ****
****                                                                        ****
********************************************************************************
/*
* Summary Statistics Template **************************************************
	local 		label 		"table_summary"                                     // (Manual) // Enter desired file name. Also used as ref label in LaTeX.
	
	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.	
	local 		columns		"mtitles("Name1" "Name2" )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
	
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 
	local   	text 	    "substitute(centering "centering $text " )"	        // (Optional) Setting balance tables text size, using text size macro.
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.

	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 	
	
	esttab 		using 		"$table_dir\`label'", $stat_format $stat_cells `locals' 
		
	eststo clear		
	
* Balance Testing Template *****************************************************

	local 		label 		"table_balance" 									// (Manual) // Enter desired file name. Also used as ref label in LaTeX.

	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.
	local 		columns		"mtitles("\textbf{Treatment}" "\textbf{Control}" "\textbf{Difference}") " 		
//                                                                              // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																				Remove all string except for "" if not used. 
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 
	local   	text 	    "substitute(centering "centering $text " )"	        // (Optional) Setting balance tables text size, using text size macro.
	
	local 		locals		" `title' `columns' `groups' `text' "        		// Compiles macros together.

	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if $stat_sample == 0         
	eststo: 	estpost sum 	$stat_vars 		if $stat_sample == 1	
	eststo: 	estpost ttest 	$stat_vars 		, by($stat_sample ) unequal 
	
	esttab 		using 		"$table_dir\`label'", $stars $balance_format $balance_cells `locals' 
	eststo 		clear 
	
* Regression Table Template ****************************************************  // Set to default format, with options to customize.

	local 		label 		"reg_" 									            // (Manual) // Enter desired file name. Also used as ref label in LaTeX.

	local 		title		"title("Line1" "Line2"\label{`label'})"	            // (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//                                                                              // \label = adding LaTeX command to create a reference label.
	local 		columns		"mtitles("\textbf{Name1}" "\textbf{Name2}" ) " 	    // (Manual) // Used to label models.
//                                                                              Customize table columns by order L-R : "Name1" "Name2" ...
// 																				Remove all string except for "" if not used. 
	local 		cells 		"collabels("dependent_var")"                        // (Manual) // When using `columns', this command allows you to label the 
//                                                                              dependent variable that the coefficients are being compared to. 
	local 		coef		"coeflabels( _cons "Constant" )"					// (Optional) Customize coefficients: (var) "New Name" ...
	local  		groups 		"refcat( var1 "\textbf{Group1}" var2 "\textbf{}", nolabel)" 
//                                                                            	// (Manual) // To add group names to set of variables in table.
//                                                                              Order process: (first var in group) "Group Name" ...
//                                                                              nolabel = used to leave rest of row blank at group name rows. 

	local 		SE			" "													// (Optional) If using other kind of SE, 
//                                                                                 Enter term you want listed that precedes the word "Standard Errors."
	local 		footer 		"r2 substitute(Standard "`SE' standard" {l} {c})"	// (Optional) r2=include r2 in footer. 
//                                                                              substitute() enters what was in SE local, but also 
//                                                                              manually reformats footer to be centered.
//																				(NOTE) could potentially affect other elements, since any 
// 																				left-aligned cells will be centered.
   
    local 		scalar 		"scalars("e_name label")" 							// If you want to add additional footer content,
// 																				enter scalar name/e(name), followed by what you want to label this scalar.
	
	local 		locals 		"`title' `columns' `cells' `coef' `groups' `footer' `scalar' " // Compiles all locals together. 
	
	eststo clear
	eststo: 	reg 	dependent_var 	independent_var	control_var1			, $regression // example format of regression. 
	estadd		local 	FE		"NO"                                            // Manually adding a scalar 

	esttab 		using  		"$table_dir\`label'", $reg_format $reg_cells $reg_decimal `locals' 
	eststo clear
	
	
* Twoway Graph Template  *******************************************************

	local 		legend	 	"legend(order() span size(small) color(white))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles		"title() xtitle() ytitle()" 						// (Manual) // Axis titles. Remove if n/a. 
	local 		xline		"xline(0.5, lcol(stone) lwidth(medthick))"		 	// (Manual) // Placement on x-axis, followed by color and thickness.
// 																								  Remove all string except for "" if not used.			
	local 		locals 		"`legend' `titles' `xline'" 						// (Optional) Add any new locals to the command 
	
	twoway 		(scatter (Y-Var1) 	(X-Var)  	if (Condition)  ,  	mcolor(edkblue) msymbol(diamond_hollow) msize(2-pt)) ///
				(line 	 (Y-Var2) 	(X-Var)						, 	lcol("187 0 0") lwidth(thick)) ///
				(lfit 	 (Y-Var1) 	(X-Var)  	if (Condition)  ,	lcol(edkblue) lwidth(medthick)) ///
				,  $graph_twoway `locals'
			
	graph 		export 		"$figure_dir\`label'"		, 	$graph_export 

* Bar Graph Template  **********************************************************	

	local 		legend 		"legend(order() span size(small) color(white))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title() xtitle() ytitle()" 						// (Manual) // Axis titles. Remove if n/a. 
	
	local 		locals 		" `legend' 	`titles' "
	
	graph 		bar (Y-Var1) (Y-Var2) (Y-Var3), over("X-Var") /// 
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) bar(3,color("187 0 0")) /// 
				$graph_hist `locals'
				
	graph 		export 		"$figure_dir\`label'"		, 	$graph_export 
	
*/	
********************************************************************************
****						  				  								****
****							  DATA CLEANING	  							****
****						  				  								****
********************************************************************************

* Import survey data ***********************************************************
import 			excel	 "$data_dir/Encuesta_de_Salida.xlsx", 		sheet("Encuesta de Salida") firstrow case(lower)

* Destring variables ***********************************************************
destring 		(clave  - cupons) (aves_de_corral - puercos)	, replace
destring 		edad miembros mayores menores venta otra_milpa_a otra_trabajado_a parcelas hectareas tiempo_cultivando cafe_cosecho cafe_intermediarios ///
				cafe_intermediarios_precio_mxn cafe_cooperativa_precio_mxn cafe_cooperativa cafe_mejor_precio_mxn cafe_peor_precio_mxn miel_produce_si ///
				miel_produce_si_mxn sembrando_vida_a ///
				, replace force

* Remove blank/irrelevant variables ********************************************
drop 			(total_ganancia_note - demographics) 	(cultivosmaiz - cultivosverduras) 	(coupons - verduras) 	(_validation_status - _tags)
drop 			ingresos cafe cafe_intermedios_precio cafe_cooperativa_precio cafe_mejor_precio cafe_peor_precio miel_produce_si_precio ///
				encuestador_questions encuestador_questions_note milpa miel encuestador_interrupcion_si encuestador_interrupcion_001 ///
				cafe_vende_porque_general cafe_vende_intermediariovende_m cafe_vende_intermediariovende_c cafe_vende_intermediariovende_p ///
				cafe_vende_cooperativavende_mil cafe_vende_cooperativavende_com cafe_vende_cooperativavende_pob miel_produce_si_unidad _index

* Remove encuestador training entries (claves < 100) ***************************
drop if 		clave 	<= 99
drop if 		clave 	== .

* Generate new usable variables ************************************************
gen 			female 				= 0 	if (sexo 			== "masculino")
replace 		female 				= 1 	if (sexo 			== "femenino")

gen 			edu_level 			= 1 	if edu 				== "primaria"
replace 		edu_level 			= 2 	if edu 				== "secundaria"
replace 		edu_level 			= 3 	if edu 				== "preparatoria"
replace 		edu_level 			= 4 	if edu 				== "universidad"

gen 			edu_missing 		= 1 	if edu_level 		== .
replace 		edu_missing 		= 0 	if edu_missing 		== .
replace 		edu_level 			= 1		if edu_missing		== 1

gen 			hambre_si 			= 1 	if (hambre 			== "sí")
replace 		hambre_si 			= 0 	if (hambre 			== "no")

gen 			otra_milpa_si 		= 1 	if (otra_milpa 		== "sí")
replace 		otra_milpa_si 		= 0 	if (otra_milpa 		== "no")

gen 			otra_trabajado_si 	= 1 	if (otra_trabajado 	== "sí")
replace 		otra_trabajado_si 	= 0 	if (otra_trabajado 	== "no")

gen 			sembrando_vida_si 	= 1 	if (sembrando_vida 	== "sí")
replace 		sembrando_vida_si 	= 0 	if (sembrando_vida 	== "no")


foreach var 	of varlist 		hambre_mesesenero - puercos 	otra_milpa_a 	otra_trabajado_a	sembrando_vida_a	cafe_cooperativa	cafe_intermediarios {
replace 		`var' 	= 	0 	if 	`var' 	==.
}

gen 			total_hambre = (hambre_mesesenero+ hambre_mesesfebrero+ hambre_mesesmarzo+ hambre_mesesabril+ hambre_mesesmayo+ ///
				hambre_mesesjunio+ hambre_mesesjulio+ hambre_mesesagosto+ hambre_mesesseptiembre+ hambre_mesesoctubre+ hambre_mesesnoviembre+ ///
				hambre_mesesdiciembre)

gen 			total_cultivos = (cultivoscultivos_maiz+ cultivoscultivos_frijol+ cultivoscultivos_cafe+ cultivoscultivos_calabaza+ ///
				cultivoscultivos_chayote+ cultivoscultivos_chile+ cultivoscultivos_platano+ cultivoscultivos_cana_de_azucar+ ///
				cultivoscultivos_naranja+ cultivoscultivos_yuca+ cultivoscultivos_camote+ cultivoscultivos_papaya+ cultivoscultivos_mango+ ///
				cultivoscultivos_hortalizas+ cultivoscultivos_verduras)

split 			actividad 
drop 			actividad

gen 			total_cafe_variedades = (cafe_variedadesvariedades_typic+ cafe_variedadesvariedades_bourb+ cafe_variedadesvariedades_marag+ ///
				cafe_variedadesvariedades_geish+ cafe_variedadesvariedades_tabi+ cafe_variedadesvariedades_catur+ cafe_variedadesvariedades_mundo+ ///
				cafe_variedadesvariedades_garni+ cafe_variedadesvariedades_catim+ cafe_variedadesvariedades_pacam+ cafe_variedadesvariedades_oro_a+ ///
				cafe_variedadesvariedades_robus)

rename 			miel_produce_si 			miel_produce_qty

gen 			miel_produce_si = 1 		if (miel_produce == "sí")
replace 		miel_produce_si = 0 		if (miel_produce == "no")

gen 			miel_alguien_si = 1 		if (miel_alguien == "sí")
replace 		miel_alguien_si = 0 		if (miel_alguien == "no")

* Drop string variables ********************************************************
drop sexo hambre edu otra_milpa otra_trabajado sembrando_vida cultivos cafe_vende_cooperativa cafe_vende_intermediario miel_produce miel_alguien 

* Rename variables *************************************************************
rename 			otra_milpa_a 						otra_milpa_ingresos
rename 			otra_trabajado_a 					otra_trabajado_ingresos
rename 			sembrando_vida_a 					sembrando_vida_ingresos
rename 			hambre_si 							ahora_hambre
rename			hambre_meses						string_hambre
rename 			cafe_variedades 					string_variedades
rename 			miel_produce_no 					miel_produce_interest
rename 			miel_produce_si_mxn 				miel_produce_precio
rename 			cafe_variedadesvariedades_typic 	variedades_typica
rename 			cafe_variedadesvariedades_bourb 	variedades_bourbon
rename 			cafe_variedadesvariedades_marag 	variedades_maragogype
rename 			cafe_variedadesvariedades_geish 	variedades_geisha
rename 			cafe_variedadesvariedades_tabi 		variedades_tabi
rename 			cafe_variedadesvariedades_catur 	variedades_caturra
rename 			cafe_variedadesvariedades_mundo 	variedades_mundo_novo
rename 			cafe_variedadesvariedades_garni 	variedades_garnica
rename 			cafe_variedadesvariedades_catim 	variedades_catimore
rename 			cafe_variedadesvariedades_pacam 	variedades_pacamara
rename 			cafe_variedadesvariedades_oro_a 	variedades_oro_azteca
rename 			cafe_variedadesvariedades_robus 	variedades_robusta
rename 			cafe_vende_intermediariovende_i 	cafe_vende_intermediario_m
rename 			dg 									cafe_vende_intermediario_c
rename 			dh 									cafe_vende_intermediario_p
rename 			cafe_vende_cooperativavende_coo 	cafe_vende_cooperativa_m
rename 			ds 									cafe_vende_cooperativa_c
rename 			dt 									cafe_vende_cooperativa_p

rename			(aves_de_corral - puercos) 			animales_=
rename			*meses* 							**
rename			*scultivo* 							**
rename 			*_si 								*
rename 			*_mxn 								*

********************************************************************************
****                                                                        ****
****						  Data Correction	  							****
****                                                                        ****
********************************************************************************


* Fix claves first before fixing result values. *************************

sort clave

replace 		clave   = 105 		if juego_1 == 401400 & clave == 150
replace 		clave   = 148 		if juego_1 == 323400 & clave == 145
replace 		clave   = 151 		if juego_1 == 465000 & clave == 181
replace 		clave   = 174 		if juego_1 == 381300 & clave == 147
replace 		clave   = 177 		if juego_1 == 441900 & clave == 169
replace 		clave   = 228 		if juego_1 == 324300 & clave == 225
replace 		clave   = 238 		if juego_1 == 288000 & clave == 235
replace 		clave   = 248 		if juego_1 == 342000 & clave == 245
replace 		clave   = 263 		if juego_1 == 498900 & clave == 243
replace 		clave   = 283 		if juego_1 == 384000 & clave == 253
replace 		clave   = 308 		if juego_1 == 300000 & clave == 305
replace 		clave   = 321 		if juego_1 == 476400 & clave == 301
replace 		juego_3 = 292800 	if clave   == 104
replace 		juego_1 = 312000 	if clave   == 126
replace 		juego_3 = 305100 	if clave   == 126
replace 		juego_2 = 404100 	if clave   == 147
replace 		juego_3 = 393600 	if clave   == 147
replace 		juego_3 = 447000 	if clave   == 157
replace 		juego_1 = 385200 	if clave   == 171
replace 		juego_1 = 270000 	if clave   == 172
replace 		juego_1 = 441300 	if clave   == 206
replace 		juego_3 = 300000 	if clave   == 255
replace 		juego_3 = 275100 	if clave   == 310
replace 		juego_3 = 426000 	if clave   == 413
replace 		juego_1 = 446100 	if clave   == 418
replace 		juego_2 = 395700 	if clave   == 440
replace 		juego_2 = 356700 	if clave   == 462

* Recalculate totals **********************************************************
replace 		total_ganancia 		= juego_1 + juego_2  + juego_3 + sorteo 
replace 		cafe_mejor_precio 	= cafe_mejor_precio / 60 if cafe_mejor_precio 		> 1000 

* Replace missing values with 0 ************************************************
replace 		cafe_intermediarios_precio 	= 0 			if cafe_intermediarios_precio	==.
replace 		cafe_cooperativa_precio  	= 0 			if cafe_cooperativa_precio		==.

// Enumerator entry error. Change male to female on 105
replace			female 				= 1			if clave == 105

// Question about household members should at least be 1. If 0, participant must be thinking of number beyond them.
replace 		miembros 			= 1 		if miembros == 0

// One entry put the age of the member rather than the quantity.
replace 		mayores 			= 1 		if mayores == 65
replace 		mayores 			= 0			if mayores == .

// There are 20 missing values in menores variable, since you can't have null number of members, 
// it should at least be 0. Assuming skipping entry is due to the answer being 0, we'll replace null with 0.
replace 		menores 			= 0 		if menores == .

// Outlier in venta that has no other data supporting 3x the next highest reported income (300k pesos = 15k usd)
replace 		venta 				= 30000 	if venta == 300000 & clave == 222

// Somehow ended up with negative value of hectares, must of been entry error.
replace 		hectareas 			= 2 		if hectareas == -2

// Entry error with participant listed with 2000 years of experience.
replace 		tiempo_cultivando 	= 20 		if tiempo_cultivando == 2000
gen 			edad_cultivando 	= edad - tiempo_cultivando 

// Enumerator names
replace 		encuestador_nombre 	= "encuestador_pedro" 		if encuestador_nombre 	== "encuestador_edro"
replace 		encuestador_nombre 	= "encuestador_joel" 		if encuestador_nombre 	== "encuestador_joel_constantino_canes"

// Add Joel to the first day of experiments.
replace 		encuestador_nombre 	= "encuestador_joel" 		if encuestador_nombre 	== "encuestador_pedro_gutierrez"

// Participant put name instead of comunidad. Participant was in directory and so comunidad was manually overwritten.
replace 		comunidad 			= "San Jeronimo Paxilha'" 	if comunidad 			== "Alfredo Moreno Gutierrez"

// Recode Education since there is only one with the college value, and so 3 = HS+
replace 		edu_level			= 3 						if edu_level == 4	

/* Coffee harvest values  (cafe_cosecho, cafe_cooperativa, cafe_intermediarios) 

cosecha - (cafe_cooperativa + cafe_intermediarios) must be >= 0
The maximum quantity of quintals is 40
Many of cosecha reports are 1/60 of sale values, thus many are reporting in quintal values than kg. (71 such cases)
Venta, hectareas, and cosecha are correlated, thus should be used to check each other. 
(Using cooperative sales data, mean harvest and hectareas are significant at 99.9%)
If sold is very large, while cosecha, venta and hectareas are low, then values should be in kg.
cafe_cooperativa & cafe_intermediarios need to be fixed first. 
Check first if cosecha * 60 is >= sold 
If not, check if cosecha * 100 / sold is < 2 and > 1
One clue is mismatched units. There are 112 such cases in the data.
*/

gen 			sold_cooperativa 	= cafe_cooperativa
replace 		sold_cooperativa 	= cafe_cooperativa 	  * 60 	if (cafe_cooperativa_unidad 	== "unidad_quintal") & cafe_cooperativa <25 
replace 		sold_cooperativa 	= cafe_cooperativa 			if cafe_cooperativa_unidad 		== "" 			 	 & cafe_cooperativa >35
replace 		sold_cooperativa 	= cafe_cooperativa 	  * 60 	if cafe_cooperativa_unidad 		== "" 			 	 & cafe_cooperativa <35
replace 		sold_cooperativa 	= cafe_cooperativa 	  * 60 	if cafe_cooperativa_unidad 		== "unidad_kilo" 	 & cafe_cooperativa <10

gen 			sold_intermediario 	= cafe_intermediarios
replace 		sold_intermediario 	= cafe_intermediarios * 60 	if (cafe_intermediarios_unidad 	== "unidad_quintal")
replace 		sold_intermediario 	= cafe_intermediarios 		if cafe_intermediarios_unidad 	== "" 				& cafe_intermediarios >45
replace 		sold_intermediario 	= cafe_intermediarios * 60 	if cafe_intermediarios_unidad 	== "" 				& cafe_intermediarios <45
replace 		sold_intermediario 	= cafe_intermediarios * 60 	if cafe_intermediarios_unidad 	!= "unidad_quintal" & cafe_intermediarios <10

gen 			total_sold 			= sold_cooperativa 		+ sold_intermediario 
gen 			diff 				= cafe_cosecho 			- total_sold 
gen 			diff_percent		= cafe_cosecho 			/ total_sold 

gen 			cosecha 			= cafe_cosecho
replace 		cosecha 			= cafe_cosecho 	* 60 	if diff_percent < 	.04 
replace 		cosecha 			= total_sold 			if diff_percent <	1 
replace 		cosecha 			= total_sold 			if cosecha 		== 	.

drop			cafe_cosecho 	diff	diff_percent ///
				cafe_cooperativa 					cafe_cooperativa_unidad ///
				cafe_intermediarios 				cafe_intermediarios_unidad /// 
				cafe_intermediarios_precio_unida 	cafe_cooperativa_precio_unidad ///
				cafe_mejor_precio_unidad 			cafe_peor_precio_unidad
				   
/* Venta 
The low values of venta are expected to be misunderstanding of the question, and are answering harvest numbers. 
0 incomes don't make sense, and so at least make venta the product of coffee harvest by 50 pesos. 
*/
replace 		venta	 	= venta 	* 60 * 50 	if venta 	<  20
replace 		venta		= venta 	* 50 		if venta 	<  100
replace 		venta 	   	= cosecha 	* 50 		if venta 	== 0 

/* Hectares
Hectares above 10 are not expected to be valid. Most of the "10" are misskeyed entries of 1. 
Meanwhile "12" is probably meant to be "1-2", and "15" is probably 1.5 
*/
replace 		hectareas 	= 10 		if hectareas == 1 	& cosecha 	>1000
replace 		hectareas 	= 1 		if hectareas >  9 	& hectareas <20 	& cosecha <700
replace 		hectareas 	= 1.5 		if hectareas == 15 	& cosecha 	<700
replace 		hectareas 	= 2 		if hectareas >= 20 	& hectareas <30 	& cosecha <700
replace 		hectareas 	= 3 		if hectareas >= 30 	& cosecha 	<700

// Correct for wrong categories entered for best and worst prices.
gen 			change 				= cafe_mejor_precio 	if cafe_mejor_precio < cafe_peor_precio
replace 		cafe_peor_precio 	= cafe_mejor_precio 	if cafe_mejor_precio < cafe_peor_precio
replace 		cafe_mejor_precio	= change				if change 			!= .
drop 			change

** Generate honey income variables
// Venta is about crop sales, and thus we assume honey was not included in the participant's calculation of venta. 
gen 			miel_produce_ingresos = 	miel_produce_qty 	* 	miel_produce_precio 
replace 		miel_produce_ingresos = 	0 	if miel_produce_ingresos == .

** Generate total income variables
gen 	total_ingresos 			=	venta	+	otra_milpa_ingresos		+	otra_trabajado_ingresos 	+ 	sembrando_vida_ingresos
gen 	total_ingresos_miel 	=	venta	+	otra_milpa_ingresos		+	otra_trabajado_ingresos 	+ 	sembrando_vida_ingresos 	+	miel_produce_ingresos

** Generate dependents variables 
gen 			dependents 		 = (mayores  + menores)
gen 			non_dependents 	 = (miembros - mayores - menores)
gen 			dependence_ratio = (mayores  + menores) 	/ 	(miembros - mayores - menores)
replace 		dependence_ratio = 0 			if mayores 		== 0 & menores == 0
replace			dependence_ratio = dependents 	if dependents 	== miembros

* Coffee Varietal Variables 
// Half of the coffee trees in survey list are hybrids that are resistant to CLR, I'm adding the percentage of producers have adopted these hybrids.
gen total_varietals_resistant 	= variedades_oro_azteca + variedades_catimore + variedades_geisha + variedades_tabi  + variedades_robusta 
gen total_varietals_susceptible = variedades_garnica + variedades_bourbon + variedades_caturra + variedades_mundo_novo + variedades_typica + variedades_maragogype ///
								+ variedades_pacamara 
gen varietals_resistance_perc	= total_varietals_resistant / (total_varietals_resistant + total_varietals_susceptible)

* generate simplified values of sales.
gen 			total_ingresos_mil 			=	total_ingresos / 1000
gen 			total_ingresos_miel_mil 	= 	total_ingresos_miel / 1000
gen 			quintal 					=  	cosecha / 60

** Generate survey date variable
gen 			region_survey = 0
replace 		region_survey = 1  	if clave < 110
replace 		region_survey = 2  	if clave >=110 & clave < 140
replace 		region_survey = 3  	if clave >=140 & clave < 201
replace 		region_survey = 4  	if clave >=201 & clave < 226
replace 		region_survey = 5  	if clave >=226 & clave < 252
replace 		region_survey = 6  	if clave >=252 & clave < 273
replace 		region_survey = 7  	if clave >=273 & clave < 299
replace 		region_survey = 8  	if clave >=299 & clave < 401
replace 		region_survey = 9  	if clave >=401 & clave < 424
replace 		region_survey = 10  if clave >=424 & clave < 447
replace 		region_survey = 11  if clave >=447

** Label Variables 

label var		otra_milpa_ingresos 			"Income from other farms"
label var		otra_trabajado_ingresos 		"Income outside of farming"
label var		sembrando_vida_ingresos 		"Income from Sembrando Vida"
label var		string_hambre					"String list of months of food insecurity"
label var		string_variedades 				"coffee varietals"
label var		cafe_mejor_precio 				"Highest price received"
label var		miel_produce_interest 			"Likert scale 1-10 interest in honey"
label var		ahora_hambre 					"1=yes, 0=no for currently hungry"
label var		otra_milpa 						"1=yes, 0=no for earning income on another farm"
label var		otra_trabajado 					"1=yes, 0=no for other work income"
label var		sembrando_vida 					"1=yes, 0=no if received"
label var		total_hambre 					"Total months of food insecurity"
label var		miel_alguien 					"1=yes, 0=no if know a honey producer"
label var		sold_cooperativa 				"kg coffee sold to cooperative"
label var		sold_intermediario 				"kg coffee sold to cooperative"
label var		total_sold 						"Total kg of coffee sold"
label var		clave 							"Participant user ID"
label var		variedades_typica 				"Typica"
label var		variedades_bourbon 				"Bourbon"
label var		variedades_maragogype 			"Maragogype"
label var		variedades_geisha 				"Geisha"
label var		variedades_caturra		 		"Caturra"
label var		variedades_tabi 				"Tabi"
label var		variedades_mundo_novo 			"Mundo novo"
label var		variedades_garnica 				"Garnica"
label var		variedades_catimore 			"Catimor"
label var		variedades_pacamara 			"Pacamara"
label var		variedades_oro_azteca 			"Oro azteca"
label var		variedades_robusta 				"Robusta"
label var		cafe_cooperativa_precio 		"Highest price received from cooperative"
label var		cafe_intermediarios_precio 		"highest price received from intermediary"
label var		cafe_vende_intermediario_m 		"vende intermediario milpa"
label var		cafe_vende_intermediario_c 		"vende intermediario comunidad"
label var		cafe_vende_intermediario_p 		"vende intermediario poblacion"
label var		cafe_vende_cooperativa_m 		"vende cooperativa milpa"
label var		cafe_vende_cooperativa_c 		"vende cooperativa comunidad"
label var		cafe_vende_cooperativa_p 		"vende cooperativa poblacion"
label var		cafe_peor_precio 				"Worst price received"
label var		cafe_vende_porque_cooperativa 	"open-ended answer"
label var		cafe_vende_porque_intermediario "open-ended answer"
label var		miel_produce_qty 				"kg of honey produced"
label var		miel_produce_precio 			"kg price of honey"
label var		edu_missing 					"1=yes, 0=no if missing edu value"
label var		actividad1 						"1st rank option if given more money"
label var		actividad2 						"2nd rank option if given more money"
label var		actividad3 						"3rd rank option if given more money"
label var		actividad4 						"4th rank option if given more money"
label var		actividad5 						"5th rank option if given more money"
label var		actividad6 						"6th rank option if given more money"
label var		miel_produce 					"1=yes, 0=no if honey producer"
label var		edad_cultivando 				"Age when first growing coffee"
label var 		edad  							"Age" 
label var		female 							"Female"
label var		edu_level 						"Education Level (1-3)"
label var		miembros      					"Household Size"
label var		dependents           			"Number of Dependents"
label var		tiempo_cultivando 				"Coffee Experience (Yrs)"
label var		hectareas                 	 	"Farm size (ha)"
label var		total_cafe_variedades      		"Coffee Varietals"
label var		total_cultivos	           		"Types of Crops"
label var		varietals_resistance_perc   	"Resistant Coffee (pct)"
label var		cosecha             			"Coffee Harvest (kg)"
label var		total_ingresos          	    "Annual Income (Pesos)"
label var		total_ingresos_miel     	    "Income (with honey)"
label var		total_hambre 		    	    "Food Insecure (months)"
label var 		total_ingresos_mil 				"Income (1,000 MXN)"
label var 		total_ingresos_miel_mil			"Income (with honey)"
label var 		quintal 						"Coffee Quintals (60kg)"
label var 		total_varietals_susceptible 	"Total Susceptible Varietals"
label var 		total_varietals_resistant		"Total Resistant Varietals"

** Save clean original dataset
save 			"$work_dir/encuesta_de_salida.dta",						replace 

********************************************************************************
****						  Merging Datasets	  							****
********************************************************************************

****  Sorteo Lottery  ***** 

merge 		1:m		clave 	using "$work_dir/sorteo_clean.dta"

replace 	sorteo 	= 		result

drop 		result 	_merge	 notes	 hardcopy

label var 	lottery 			"sorteo selection"

** Recalculate totals
replace 	total_ganancia 	= juego_1 + juego_2  + juego_3 + sorteo 
replace 	total_ganancia 	= juego_1 + juego_2  + juego_3  if (sorteo == .)
replace 	cupons 			= total_ganancia / 250000
replace 	cupons 			= round(cupons, 1)

** Update clean original dataset
save 		"$work_dir/encuesta_de_salida.dta",							replace 

**** Community Codes  ****

clear
import 		excel "$data_dir/Community codes.xlsx", 					sheet("preserved") firstrow

save 		"$work_dir/community_codes.dta",							replace 

use 		"$work_dir/encuesta_de_salida.dta",							clear

merge 		m:1 	clave 	using "$work_dir/community_codes.dta",		keepusing (community_code)
drop 		_merge

** Save a new functional version
save 		"$work_dir/encuesta_de_salida_clean.dta",					replace 

****  Crossreference  ****

* Import YA crossref codes, and Chabtic filter
clear
import 		excel "$data_dir/crossref.xlsx", 	sheet("Sheet1") firstrow case(lower)

* dropping 0 creates a variable of all values representing chabtic honey producers & cooperative members.
replace 	chabtic = . 	if chabtic	== 0
replace 	ya 		= . 	if ya 		== 0

save 		"$work_dir/crossref.dta",									replace 

use 		"$work_dir/encuesta_de_salida_clean.dta",					clear

merge 		1:m 	clave 	using "$work_dir/crossref.dta"
drop 		_merge

* Create dummy variable for membership
gen 		nonmember 	= 	0 	if ya 		 != .
replace 	nonmember	= 	1 	if ya 		 == .
gen 		coop_member = 	1
replace 	coop_member = 	0 	if nonmember == 1
label var	coop_member 				"Cooperative Member"


** Save experiment-related version of survey data.
save 		"$work_dir/encuesta_de_salida_clean.dta",					replace 

** Merge Chabtic data 
merge 		m:1 chabtic using "$work_dir/chabtic.dta",	force
drop if 	_merge == 2
drop 		municipio 	nombre	 fecha_ingreso	 antiguedad	 _merge
rename 		cosecho 	miel_cosecho
sort 		clave 

** Merge Coffee Sales data 
merge 		m:1 ya using "$work_dir/acopio_mean.dta",		force
drop if 	_merge == 2
drop 		_merge

********************************************************************************
****				  Create New Honey Variables	  						****
********************************************************************************

** Create subset of honey producers that are producing enough honey that could plausibly affect food security issues.
** Update: didn't really end up using this variable.
gen 	honey_functional = 0
replace honey_functional = 1 if miel_produce_qty >= 25

** Create Honey Regions
gen 	region_honey = 0
replace region_honey = 1  if region_survey == 4
replace region_honey = 1  if region_survey == 5
replace region_honey = 1  if region_survey == 7
replace region_honey = 1  if region_survey == 9
replace region_honey = 1  if region_survey == 10
// These regions are the regions with >20% honey producer representation within survey region. 

** Label New Variables
label var 	cosecho_colmenas 		"Mean harvest per beehive"
label var 	pergamino_mean 			"Mean average coffee sale to YA"
label var 	miel_mean 				"Mean average honey sale to YA"
label var 	ingreso_pergamino_mean 	"Mean average coffee income from YA"
label var 	ingreso_miel_mean 		"Mean average honey income from YA"
label var 	ingreso_jabon_mean 		"Mean average soap income from YA"
label var 	ingreso_total_mean 		"Mean average total income from YA"

** Generate honey producer regional density
gen 		person 	= 1
bysort 		region_survey : egen region_producers 		= total (person)
bysort 		region_survey : egen region_honey_producers = total (miel_produce)
gen			region_honey_perc							= region_honey_producers 	/ region_producers
label var	region_honey_perc           				"Region Honey Pop. (pct)"

** Save new honey dataset
save 		"$work_dir/encuesta_miel.dta",					replace 

********************************************************************************
****							  Panel Data	  							****
********************************************************************************

reshape 	long hambre_	, 	i(clave) 	j(meses) 	string

rename 		hambre_ 		hambre_mes

** Create month variable

gen 		month 	= 1 	if meses == "enero"
replace 	month 	= 2 	if meses == "febrero"
replace 	month 	= 3 	if meses == "marzo"
replace 	month 	= 4 	if meses == "abril"
replace 	month 	= 5 	if meses == "mayo"
replace 	month 	= 6 	if meses == "junio"
replace 	month 	= 7 	if meses == "julio"
replace 	month 	= 8 	if meses == "agosto"
replace 	month 	= 9 	if meses == "septiembre"
replace 	month 	= 10 	if meses == "octubre"
replace 	month 	= 11 	if meses == "noviembre"
replace 	month 	= 12 	if meses == "diciembre"

** Time Series
gen year = 2021
gen date = ym(year,month)
format date %tm
drop year
xtset clave date, monthly

** Create Genaralized Seasons (Lean =1, Winter =2, Coffee Harvest =3, Honey Harvest =4) 
gen 		month_season		 	= 0	
replace 	month_season		 	= 1		if meses == "julio" 	|  meses == "agosto" 	| meses == "septiembre" 	
replace 	month_season		 	= 2		if meses == "octubre" 	|  meses == "noviembre" | meses == "diciembre" 	
replace 	month_season		 	= 3 	if meses == "enero" 	|  meses == "febrero" 	| meses == "marzo" 
replace 	month_season		 	= 4		if meses == "abril" 	|  meses == "mayo" 		| meses == "junio" 

** Create True Lean Season (june-august)
gen 		month_lean 			 	= 0
replace 	month_lean			 	= 1		if meses == "junio"		|  meses == "julio"  	| meses == "agosto"

** Create Honey Harvest Season (april - june)
gen 		month_honey  			= 0
replace 	month_honey  			= 1 	if month_season == 4

** Create Complete Coffee Harvest Season (december - april)
gen 		month_coffee_harvest 	= 0
replace 	month_coffee_harvest 	= 1 	if meses == "diciembre"
replace 	month_coffee_harvest 	= 1 	if meses == "enero"
replace 	month_coffee_harvest 	= 1 	if meses == "febrero"
replace 	month_coffee_harvest 	= 1 	if meses == "marzo"
replace 	month_coffee_harvest 	= 1 	if meses == "abril"

** Generate percentile groups
xtile 	decile_ingresos 		= total_ingresos, 	nq(10)
replace decile_ingresos 		= decile_ingresos 	* 10 - 10

xtile 	quartile_ingresos 		= total_ingresos, 	nq(4)
replace	quartile_ingresos		= quartile_ingresos * 25 - 25

xtile 	tercile_ingresos 		= total_ingresos, 	nq(3)
replace	tercile_ingresos		= tercile_ingresos * 33 - 33

xtile 	decile_venta 			= venta, 			nq(10)
replace	decile_venta 			= decile_venta 		* 10 - 10

xtile 	decile_cosecha 			= venta, 			nq(10)
replace	decile_cosecha	 		= decile_cosecha 	* 10 - 10

** Add log values
gen lingreso_miel_mean 		= log(ingreso_miel_mean )
gen lingreso_pergamino_mean = log(ingreso_pergamino_mean )
gen lingreso_total_mean 	= log(ingreso_total_mean )
gen lcosecha				= log(cosecha)
gen ltotal_ingresos			= log(total_ingresos)
gen lventa					= log(venta)

** Save new panel dataset
save 		"$work_dir/miel_panel.dta",					replace 

********************************************************************************
****						 English Version	  							****
********************************************************************************


rename 	(clave 	meses 	total_ganancia 		comunidad edad 	miembros 		mayores 		menores 		venta 		otra_milpa_ingresos otra_trabajado_ingresos) /// 
		(id 	months 	total_game_earnings community age 	family_members 	family_older 	family_younger 	income_farm income_other_farm 	income_other_work)

rename 	(hambre_mes 		parcelas 		hectareas 		produccion_porcentaje total_hambre 			total_cultivos 		total_cafe_variedades 	miel_produce) /// 
		(food_insecurity 	farm_parcels 	farm_hectares 	farm_coffee_intensity total_food_insecurity total_types_crops 	total_coffee_varietals 	honey_producer)

rename 	(juego_1 	juego_2 juego_3 sorteo 			cupons 	clima 			sembrando_vida_ingresos string_hambre 			total_ingresos_miel miel_alguien) /// 
		(game_1 	game_2 	game_3 	lottery_result 	coupons survey_weather 	income_sembrando_vida 	string_food_insecurity 	total_income_honey 	neighbor_honey_producer)

rename 	(total_ingresos animales_aves_de_corral animales_caballos 	animales_mulas 	animales_burros animales_borregos 	animales_cabezas 	animales_puercos) /// 
		(total_income 	animals_poultry 		animals_horses 		animals_mules 	animals_donkeys animals_sheep 		animals_cattle 		animals_pigs)

rename 	(cultivos_maiz 	cultivos_frijol cultivos_cafe 	cultivos_calabaza 	cultivos_chayote 	cultivos_chile 	cultivos_platano 	cultivos_cana_de_azucar) /// 
		(crops_corn 	crops_beans 	crops_coffee 	crops_pumpkin 		crops_squash 		crops_chili 	crops_banana 		crops_sugar_cane)

rename 	(cultivos_naranja 	cultivos_yuca 	cultivos_camote 	cultivos_papaya cultivos_mango 	cultivos_hortalizas cultivos_verduras 	tiempo_cultivando) ///
		(crops_orange 		crops_yucca 	crops_sweet_potato 	crops_papaya 	crops_mango 	crops_veg_misc 		crops_veg_greens 	coffee_experience)

rename 	(string_variedades 	variedades_typica 	variedades_bourbon 	variedades_maragogype 	variedades_geisha 	variedades_tabi variedades_caturra) /// 
		(string_varietals 	varietals_typica 	varietals_bourbon 	varietals_margogype 	varietals_geisha 	varietals_tabi 	varietals_caturra)

rename 	(variedades_mundo_novo  variedades_garnica 	variedades_catimore variedades_pacamara variedades_oro_azteca 	variedades_robusta) /// 
		(varietals_mundo_novo 	varietals_garnica 	varietals_catimore 	varietals_pacamara 	varietals_oro_azteca 	varietals_robusta)

rename 	(cafe_intermediarios_precio cafe_vende_intermediario_m 	cafe_vende_intermediario_c 		cafe_vende_intermediario_p) /// 
		(coffee_coyote_price 		coffee_coyote_sale_f 		coffee_coyote_sale_c 			coffee_coyote_sale_t)

rename 	(cafe_cooperativa_precio 	cafe_vende_cooperativa_m 	cafe_vende_cooperativa_c 	cafe_vende_cooperativa_p 	cafe_mejor_precio cafe_peor_precio) /// 
		(coffee_coop_price 			coffee_coop_sale_f 			coffee_coop_sale_c 			coffee_coop_sale_t 			coffee_price_best coffee_price_worst)

rename 	(miel_produce_qty 	miel_produce_precio 	miel_produce_interest 	encuestador_nombre 	encuestador_interrupcion) /// 
		(honey_produce_qty 	honey_produce_price 	honey_interest 			enumerator_name 	enumerator_interruption)

rename 	(ahora_hambre 		otra_milpa 				otra_trabajado 			edad_cultivando) /// 
		(survey_hungry_yn 	yn_income_other_farm 	yn_income_other_work 	age_coffee_start)

rename 	(actividad1 actividad2 	actividad3 	actividad4 	actividad5 	actividad6 	lottery 		ya 			member) /// 
		(rank_1 	rank_2 		rank_3 		rank_4 		rank_5 		rank_6 		lottery_level  	coop_id 	member_type)

rename 	(sold_cooperativa 	sold_intermediario 	cosecha 		miel_produce_ingresos 	cafe_vende_porque_cooperativa 	cafe_vende_porque_intermediario) ///
		(sold_coop 			sold_coyote 		coffee_harvest 	income_honey			coffee_coop_answer 				coffee_coyote_answer)

rename 	(decile_ingresos 	quartile_ingresos 	tercile_ingresos 	decile_venta 		decile_cosecha 			lcosecha 			ltotal_ingresos lventa) ///
		(decile_income 		quartile_income 	tercile_income 		decile_income_farm 	decile_coffee_harvest 	l_coffee_harvest 	l_total_income 	l_income_farm)

** Rename months		
replace 	months 	= "january" 	if months == "enero"
replace 	months 	= "february" 	if months == "febrero"
replace 	months 	= "march" 		if months == "marzo"
replace 	months 	= "april" 		if months == "abril"
replace 	months 	= "may" 		if months == "mayo"
replace 	months 	= "june" 		if months == "junio"
replace 	months 	= "july" 		if months == "julio"
replace 	months 	= "august" 		if months == "agosto"
replace 	months 	= "september" 	if months == "septiembre"
replace 	months 	= "october" 	if months == "octubre"
replace 	months 	= "november" 	if months == "noviembre"
replace 	months 	= "december" 	if months == "diciembre"


save 			"$work_dir/honey_panel_english.dta"	, 			replace

	
********************************************************************************
****						  				  								****
****							  Estimation	  							****
****						  				  								****
********************************************************************************

********************************************************************************
****							  Table (1):	 	 						****
****					Summary Statistics: Regional Means	  				****
********************************************************************************

	use 		"$work_dir/encuesta_miel.dta", clear

** 	local 		stat_vars		"age female edu_level family_members dependents coop_member coffee_experience farm_hectares total_coffee_varietals total_types_crops varietals_resistance_perc coffee_harvest total_income total_income_honey total_food_insecurity region_honey_perc"												// (Manual) // Enter variables that are to be measured.

	local 		region 			" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" " 
	
	local 		label 		"summary_stats"
	
	local 		title		"title("Summary Statistics: Regional Demographic Mean Values""\label{`label'}")"		// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
																								// Remove all string except for "" if not used.
	local 		columns		"mtitles("Pop." `region' )" 		   				 // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
 																								// Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	

	local 		text 		"substitute(centering "centering \scriptsize")"
	
	local 		locals		" `title' `columns' `groups' `text' "         // Compiles macros together.
	
	eststo 		clear
	
	eststo: 	quietly estpost sum $stat_vars 
	
	foreach 	y of numlist 		1 2 3 4 5 6 7 8 9 10 11 {
	eststo: 	quietly estpost sum $stat_vars 	if $stat_sample == `y' 
}	

	esttab 		using 		"$table_dir\table_`label'", $stat_format $stat_cells `locals' 
	
	eststo 		clear	

	
********************************************************************************
****							  Table (2):	 	 						****
****	  			Summary Stats: Honey vs. Non-Honey		  				****
********************************************************************************

	local 		label 		"summary_honey"

	local 		title		"title("Summary Statistics: Honey Producers vs. Non-Honey"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.

	gen 		reverse_miel_produce = 0
	replace 	reverse_miel_produce = 1 	if $balance_sample == 0
	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if $balance_sample == 1
	eststo: 	estpost sum 	$stat_vars 		if $balance_sample == 0	
	eststo: 	estpost ttest 	$stat_vars 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 

********************************************************************************
****							  Table (3):	 	 						****
****				 	Summary Stats: Coffee Varietals	  					****
********************************************************************************		
	
	local 		label 		"varietals"

	local 		vars 		"variedades_garnica variedades_bourbon variedades_caturra variedades_mundo_novo variedades_typica variedades_maragogype variedades_pacamara variedades_oro_azteca variedades_catimore variedades_geisha variedades_tabi variedades_robusta total_varietals_resistant total_varietals_susceptible varietals_resistance_perc"
	
	local 		title		"title("Coffee Varieties: Honey Producers vs. Non-Honey Producers"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Producers}" "\textbf{  Non-Honey  }" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(variedades_garnica "\textbf{  Susceptible to CLR:}" variedades_oro_azteca "\textbf{  Resistant to CLR:}" total_varietals_resistant "\textbf{  Resistant vs. Susceptible:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.
	
	eststo 		clear
	eststo: 	estpost sum 	`vars' 		if $balance_sample == 1
	eststo: 	estpost sum 	`vars' 		if $balance_sample == 0	
	eststo: 	estpost ttest 	`vars' 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 	

********************************************************************************
****							  Table (4):	 	 						****
****					  Summary Stats: Honey Regions	 	 				****
********************************************************************************
	local 		sample_regions "region_honey"

	local 		label 		"summary_region"

	local 		title		"title("Summary Statistics: Honey Regions vs. Non-Honey Regions"\label{`label'})"	// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 Remove all string except for "" if not used.
	local 		columns		"mtitles("\textbf{Honey Regions}" "\textbf{Non-Honey Regions}" "\textbf{Difference}") " 		    // (Manual) // Customize table columns by order L-R : "Name1" "Name2" ...
// 																								Remove all string except for "" if not used. 
	local  		groups 		"refcat(edad "\textbf{Demographics:}" hectareas "\textbf{Farm Characteristics:}" total_ingresos_mil "\textbf{Outcome Variables:}", nolabel)"	
	
	local 		text 		"substitute(centering "centering \small" )"
	
	local 		locals		" `title' `columns' `groups' `text' "        						// Compiles macros together.
	
	gen 		reverse_honey_region = 0
	replace 	reverse_honey_region = 1 	if `sample_regions' == 0
	
	eststo 		clear
	eststo: 	estpost sum 	$stat_vars 		if `sample_regions' == 1
	eststo: 	estpost sum 	$stat_vars 		if `sample_regions' == 0	
	eststo: 	estpost ttest 	$stat_vars 		, by(reverse_miel_produce) unequal

	esttab 		using 		"$table_dir\table_`label'", $stars $balance_format $balance_cells `locals'  // (Manual) // Replace "(file_name)" with table file name.  	
	eststo 		clear 
	
********************************************************************************
****							  Figure (4):	 	 						****
****						  Seasonality Data	 	 						****
********************************************************************************

	use 			"$work_dir/frequencies.dta"	, clear

	local 		legend 		"legend(order(1 "Coffee Sold" 2 "Honey Sold" 3 "Food Insecurity" )region(fcolor(white)))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title(Seasonal Effects) ytitle(Percentage of Annual Occurence)" 						// (Manual) // Axis titles. Remove if n/a. 
	
	local 		locals 		" `legend' `titles' "
	
	graph 		bar coffee_sales_percent honey_sales_percent food_insecurity_percent, over(month) ///
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) bar(3,color("187 0 0")) /// 
				$graph_hist `locals'
				
	graph 		export 		"$figure_dir\graph_frequencies.png"		, 	$graph_export 

********************************************************************************
****							  Figure (5):	 	 						****
****						 	 Food Insecurity	 	 					****
********************************************************************************	
	
	use 			"$work_dir/honey_panel_english.dta"	, clear

	local 		legend 		" " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title("Percentage of Population Experiencing" "Food Insecurity by Month") ytitle("Food Insecurity") "
	local 		lines 		"yline(.25)"
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar food_insecurity, over(month) /// 
				bar(1,color("187 0 0")) $graph_hist `locals'

	graph 		export 		"$figure_dir/graph_insecurity.png"				, $graph_export

********************************************************************************
****							  Table (5):	 	 						****
****						 	 Food Insecurity	 	 					****
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
	
********************************************************************************
****							  Table (6):	 	 						****
****						 	 Diff-in-Diff	 	 						****
********************************************************************************

	local 		label 		"DiD"

	local 		title		"title("Effect of Honey Producers in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{Baseline}  " "\textbf{Household FE}" " \textbf{Demographic Controls}") "   						
	local 		edu 		" 2.edu_level "Secondary Edu." 3.edu_level "High School Edu." "
	local 		cells 		"collabels("Food Insecurity" "SE")"
	local 		coef		"coeflabels( 1.honey_producer#1.month_honey "Producer x Season" 1.honey_producer "Honey Producer" 1.month_honey "Honey Season" `edu' _cons "Constant" ) wide nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local  		groups 		"refcat(female "\textbf{Controls:}", nolabel)"	
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} "0.00         &      (.)" " & ") "	// (Optional) r2=include r2 in footer. substitute() enters what was in SE
				//																			  		global, but also manually reformats footer to be centered.
					//																		  		(NOTE) could potentially affect other elements, since any 
 						//															  		  		left-aligned cells will be centered.
    local 		scalar 		"scalars("FE Household fixed effects")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' `groups' " // Compiles all globals together. 
	
	eststo clear
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey				, $regression
	estadd		local 	FE		"NO"
	eststo:		reghdfe food_insecurity 	honey_producer##month_honey					, $regression absorb(id)
	estadd 		local 	FE 		"YES"
	eststo: 	reg 	food_insecurity 	honey_producer##month_honey female age i.edu_level family_members dependents coop_member coffee_experience , $regression
	estadd		local 	FE 		"NO"
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear
	
********************************************************************************
****							  figure (6):	 	 						****
****						 OLS parallel trends	 	 					****
********************************************************************************							
							
	use 			"$work_dir/honey_panel_english.dta"	, clear							

** Collapse Monthly Food Insecurity Data 

	gen 	coffee_mean = (honey_producer==0)
	gen 	honey_mean 	= (honey_producer==1) 
	collapse (mean) food_insecurity (sd) sd=food_insecurity (semean) se=food_insecurity , by(month_honey honey_mean coffee_mean)

	gen 	type =1 	if honey_mean ==1
	replace type =2 	if coffee_mean 
	drop 	sd se

	reshape wide food_insecurity  honey_mean coffee_mean , i(month_honey) j(type )

** Manually Create Parallel Trends

	gen 		predict_a 	= 	food_insecurity2
	replace 	predict_a 	= 	-predict_a 			if month_honey ==0
	egen 		predict_b 	= 	total(predict_a)
	replace 	predict_a 	= 	predict_b 			if month_honey ==1
	replace 	predict_a 	= 	food_insecurity1 	if month_honey ==0
	egen 		predict_c 	= 	total(predict_a)
	replace 	predict_c 	= 	predict_a 			if month_honey ==0
	rename 		predict_c	 	predict_honey

** Create Graph


	local 		legend	 	"legend(order(1 "Honey Producers" 2 "Non-Honey Producers" 3 "Parallel Trend for Honey Producers") region(fcolor(white)) size(small) span)" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles		"title("Food Insecurity between Honey Producers" "& Non-Honey Producers") xtitle("Non-Honey Season vs. Honey Harvest Season") ytitle(Food Insecurity Percentage)" 						// (Manual) // Axis titles. Remove if n/a. 
	local 		xline		"xlabel(0.01 "(Jul-Feb)" 0.97 "(Mar-Jun)")"		 	// (Manual) // Placement on x-axis, followed by color and thickness.
// 																								  Remove all string except for "" if not used.			
	local 		locals 		"`legend' `titles' `xline'" 						// (Optional) Add any new locals to the command 
	
	twoway 		(line food_insecurity1 month_honey, lcol(edkblue) lwidth(thick)) /// 
				(line food_insecurity2 month_honey, lwidth(thick)) /// 
				(line predict_honey month_honey, lcol(edkblue) lwidth(thick) lpattern(dash)) /// 
				,  $graph_twoway `locals'
	graph 		export 		"$figure_dir\graph_parallel_trends.png"		, 	$graph_export 
	
********************************************************************************
****							  table (7):	 	 						****
****						 2SLS Diff-in-Diff		 	 					****
********************************************************************************

	use 			"$work_dir/honey_panel_english.dta"	, clear	


************     Model (6): Honey producers during honey harvest, with individual fixed effects     **************

	local 		label 		"IV"

	local 		title		"title("Effect of Honey Producers in Honey Season on Food Insecurity"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
//																								 	Remove all string except for "" if not used.
	local 		columns 	"mtitles("  \textbf{OLS}  " "\textbf{1st Stage}" " \textbf{IV}") "   						
	local 		cells 		"collabels("Food Insecurity") drop(honey_producer)"
	local 		coef		"coeflabels(honey_producer_x_honey_season  "Producer x Season" honey_season "Honey Season" region_honey_share "IV: Honey In Region" _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} ) "	// (Optional) r2=include r2 in footer. substitute() enters what was in SE

    local 		scalar 		"scalars("FE Household fixed effects" "F F-Statistic")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' " // Compiles all globals together. 
	
	
** User friendly variables  
	gen 	honey_season 					= month_honey
	gen 	honey_producer_x_honey_season 	= honey_producer 		* 	month_honey
	
	eststo clear
	eststo: 	reghdfe 	food_insecurity 	honey_producer_x_honey_season 	honey_season 	honey_producer			, $regression  absorb(id)
	estadd		local 	FE		"YES"
	
***********     Model (7): First Stage 2SLS Regression 	   *******************			
				
	use 				"$work_dir/encuesta_miel.dta", clear

** generate IV of share of honey producers in each survey region within non-panel data form of survey data (encuesta_miel). 


	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if miel_produce == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted
	rename 	miel_produce honey_producer

	eststo:		reg 	honey_producer region_honey_share 
	estadd 		local 	FE 		"NO"
					
***********    Model (8): 2nd Stage 2SLS with IV   ******************				

	use 			"$work_dir/honey_panel_english.dta"	, clear	

** Generate IV
	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if honey_producer == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted

** Interaction terms for IV
	gen 	did_hp_honey 			= honey_producer 		* 	month_honey
	gen 	iv_share_honey			= 	region_honey_share 	* 	month_honey

** User friendly variables 
	gen 	honey_season 					= month_honey
	gen 	honey_producer_x_honey_season 	= did_hp_honey


	eststo: 	xtivreg 	food_insecurity ( ///
													honey_producer_x_honey_season  	honey_producer 		 /// 
												= 	iv_share_honey					region_honey_share 	 /// 
											) ///
													honey_season , fe  $regression
	estadd		local 	FE 		"YES"
	
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear							 

********************************************************************************
****						 	 Hausman Test 		   						****
********************************************************************************

												
reg 		food_insecurity 		honey_producer_x_honey_season 	honey_producer  	honey_season 
estimates 	store ols

xtivreg 	food_insecurity 	( 	honey_producer_x_honey_season 	honey_producer ///
								= 	iv_share_honey					region_honey_share ) honey_season
estimates 	store iv

hausman 	iv ols

********************************************************************************
****							  table (8):	 	 						****
****				Robustness Check 2SLS Lean Months	 	 				****
********************************************************************************

	use 			"$work_dir/honey_panel_english.dta"	, clear	


************     Model (6): Honey producers during honey harvest, with individual fixed effects     **************

	local 		label 		"IV_lean"
	local 		title		"title("Robustness Check: Lean Season as Treatment Period"\label{`label'})"				// (Manual) // For mutliple lines, use "Line1" "Line2" for multiple line.
	local 		columns 	"mtitles("  \textbf{OLS}  " "\textbf{1st Stage}" " \textbf{IV}") "   						
	local 		cells 		"collabels("Food Insecurity") drop(honey_producer)"
	local 		coef		"coeflabels(honey_producer_x_lean_season  "Producer x Season" lean_season "lean Season" region_honey_share "IV: Honey In Region" _cons "Constant" ) nobaselevels"				// (Optional) Customize all coefficients with coeflabels: (var) "New Name" ...
	local 		decimal		"2"													// (Optional) default set for 2 decimal points for both coefficient & SE.
	local 		SE			"Clustered"											// (Optional) Replace "Standard" with type of standard errors if not normal.
 			//																				  		Enter term you want listed that precedes the word "Errors."
	local 		footer 		"r2 substitute(centering "centering \small" Standard "`SE' standard" {l} {c} ) "	// (Optional) r2=include r2 in footer. substitute() enters what was in SE

    local 		scalar 		"scalars("FE Household fixed effects" "F F-Statistic")"																									
																									
	local 		locals 		"`title' `columns' `cells' `coef' b(`decimal') se(`decimal') `footer' `scalar' " // Compiles all globals together. 

*********      Model (6) lean robustness: Honey producers during lean season, with individual fixed effects  *********

** User friendly variables  
	gen 	lean_season 					= month_lean
	gen 	did_hp_lean 					= honey_producer 		* 	month_lean
	gen 	honey_producer_x_lean_season 	= did_hp_lean

	eststo clear
	eststo: 	reghdfe 	food_insecurity 	honey_producer_x_lean_season 	lean_season 	honey_producer			, $regression  absorb(id)
	estadd		local 	FE		"YES"
				
********    Model (7) lean robustness: First Stage 2SLS Regression 	 ************			
			
			
use 				"$work_dir/encuesta_miel.dta", clear
** generate IV of share of honey producers in each survey region within non-panel data form of survey data (encuesta_miel). 
	gen 	region_producers_adjusted					= region_producers - 1
	gen 	region_honey_producers_adjusted 			= region_honey_producers
	replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if miel_produce == 1
	gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted
	rename 	miel_produce honey_producer

	eststo:		reg 	honey_producer region_honey_share 
	estadd 		local 	FE 		"NO"
					
					
**********   Model (8) lean robustness: 2nd Stage 2SLS with IV       ***************				

use 			"$work_dir/honey_panel_english.dta"	, clear	

** Generate IV

gen 	region_producers_adjusted					= region_producers - 1
gen 	region_honey_producers_adjusted 			= region_honey_producers
replace region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if honey_producer == 1
gen 	region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted

** Interaction terms for IV
gen 	did_hp_lean 			= honey_producer 		* 	month_lean
gen 	iv_share_lean			= region_honey_share 	* 	month_lean

** User friendly variables 
gen 	lean_season 					= month_lean
gen 	honey_producer_x_lean_season 	= did_hp_lean


	eststo: 	xtivreg 	food_insecurity ( ///
													honey_producer_x_lean_season  	honey_producer 		 /// 
												= 	iv_share_lean					region_honey_share 	 /// 
											) ///
													lean_season , fe  $regression
	estadd		local 	FE 		"YES"
	
	esttab 		using  		"$table_dir\table_`label'", $stars $reg_format $reg_cells `locals' 
	eststo clear							

********************************************************************************
****						 	 Hausman Test 		   						****
********************************************************************************

												
reg 		food_insecurity 		honey_producer_x_lean_season 	honey_producer  	lean_season 
estimates 	store ols

xtivreg 	food_insecurity 	( 	honey_producer_x_lean_season 	honey_producer ///
								= 	iv_share_lean					region_honey_share ) lean_season
estimates 	store iv

hausman 	iv ols


********************************************************************************
****							  figure (7):	 	 						****
****							Regional Counts	 	 						****
********************************************************************************

use 			"$work_dir/honey_panel_english.dta"	, clear	

/* Honey takeup has an endogeneity problem in that we don't know what causes coffee producers to adopt honey.
But once they do, they typically borrow a starter hive from a neighbor. 
Thus being in a region with a higher percentage of beekeeping neighbors increases the capacity to adopt honey.

Create a variable that calculates the percentage of neighbors in a given community are honey producers.
But remove the individual observation to jacknife the instrument.
*/

	local 		legend 		"legend(order(1 "Region Population" 2 "Honey Producers" )) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title("Honey Producers in Each Survey Region") ytitle("Regional Counts") "
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar region_producers 	region_honey_producers 	, over(region_survey) /// 
				bar(1, color("103 71 54")) bar(2, color("235 188 78")) ///  
				$graph_hist `locals' 
				
graph export 	"$figure_dir/graph_regional_counts.png"				, $graph_export

********************************************************************************
****							  figure (8):	 	 						****
****						Regional Honey Percentage 	 					****
********************************************************************************

	local 		legend 		"legend(order(1 "Region Population" 2 "Honey Producers" )) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"title("Percentage of Honey Producers" "in Each Survey Region") ytitle("Region Percent")"
	local 		lines 		"yline(.2)"
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar region_honey_perc, over(region_survey) bar(1, color("235 188 78")) ///  
				$graph_hist `locals' 
				
graph export 	"$figure_dir/graph_regional_percent.png"				, $graph_export



********************************************************************************
****							  figure (9):	 	 						****
****			Income distribution Between Honey & Non-honey	 			****
********************************************************************************

use 							"$work_dir/honey_panel_english.dta", clear

** Types of income

	gen 	perc_income_farm 		= income_farm 			/ 	total_income_honey 
	gen 	perc_income_honey		= income_honey 			/ 	total_income_honey 
	gen 	perc_income_other_work 	= income_other_work 	/ 	total_income_honey 
	gen 	perc_income_other_farm 	= income_other_farm 	/ 	total_income_honey 
	gen 	perc_income_off_farm	= (income_other_work 	+ 	income_other_farm) 	/ total_income_honey	

	local 		legend 		"by(, legend(on)) legend(order (1 "Coffee Income" 2 "Honey Income" 3 "Internal Migration Income" 4 "Neighboring Farm Income"))" 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"by(, title("Percentage of Total Income Between" "Honey Producers and Non-Honey Producers")) ytitle("Region Percent")"
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "
	
	graph 		bar (mean) perc_income_farm (mean) perc_income_honey (mean) perc_income_other_work (mean) perc_income_other_farm, by(honey_producer) ///
				$graph_hist `locals' 
				
graph export 	"$figure_dir/graph_income_sources.png"				, $graph_export


********************************************************************************
****							  figure (10):	 	 						****
****				External Income Between Honey & Non-honey 	 			****
********************************************************************************	
	
	use 					"$work_dir/honey_panel_english.dta", clear

	local 		legend 		"legend(order(1 "Only Internal Migration" 2 "Only Neighboring Farm Income" 3 "Used both Off-Farm Strategies" 4 "No Off-Farm Income" 5 "Fitted Values Line") size(small)) " 	// (Manual) // Order (number) "name" (number) "name" ... 
	local 		titles 		"by(, title("Off-Farm Income between Honey Producers" "and Non-Honey Producers")) xtitle("Log Neighboring Farm Income") ytitle("Log Internal Migration Income")"
	local 		lines 		""
	
	local 		locals 		" `legend' `titles' `lines' "

** Types of income

	gen 	l_income_other_work 	= 	log(income_other_work)
	gen 	l_income_other_farm 	= 	log(income_other_farm)
	replace	l_income_other_work		= 	0	if l_income_other_work == .
	replace	l_income_other_farm		= 	0	if l_income_other_farm == .

		
	twoway 	(scatter l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm ==0, msymbol(triangle)) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work ==0 & l_income_other_farm !=0, msymbol(triangle)) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm !=0 ) ///
			(scatter l_income_other_work  l_income_other_farm if l_income_other_work ==0 & l_income_other_farm ==0 ) ///
			(lfit 	 l_income_other_work  l_income_other_farm if l_income_other_work !=0 & l_income_other_farm !=0) ///
			, by(honey_producer) $graph_hist `locals' 

	graph export "$figure_dir/graph_other_income.png"				, $graph_export