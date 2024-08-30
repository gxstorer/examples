clear 
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

gen				edu_middle_school	= 0
replace			edu_middle_school	= 100 	if edu_level		== 2

gen				edu_high_school	= 0
replace			edu_high_school	= 100 		if edu_level		== 3 | edu_level == 4

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
label var		female 							"Gender (1 = Female)"
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
label var 		quintal 						"Coffee Harvest (1 Quintal = 60kg)"
label var 		total_varietals_susceptible 	"Total Susceptible Varietals"
label var 		total_varietals_resistant		"Total Resistant Varietals"
label var 		edu_middle_school				"Completed Only Middle School (pct)"
label var 		edu_high_school					"Completed High School (pct)"

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
replace 	region_honey_perc							= region_honey_perc * 100
label var	region_honey_perc           				"Region Honey Pop. (pct)"

** Generate IV
gen 		region_producers_adjusted					= region_producers - 1
gen 		region_honey_producers_adjusted 			= region_honey_producers
replace 	region_honey_producers_adjusted 			= (region_honey_producers) - 1  	if miel_produce == 1
gen 		region_honey_share 							= region_honey_producers_adjusted / region_producers_adjusted
label var 	region_producers_adjusted 					"Jackknifed count of neighbors in region"
label var 	region_honey_producers_adjusted 			"Jackknifed count of honey producing neighbors in region"
label var 	region_honey_share							"Percentage of neighbors that are honey producers"

** Save new honey dataset
save 		"$work_dir/encuesta_miel.dta",					replace 


********************************************************************************
****					  Survey Location Data	 	 						****
********************************************************************************

use 		"$work_dir/survey_location_points.dta", 			clear 


label var 	community_pop 					"Region Population"
label var 	community_altitude_meters 		"Regional Elevation (MASL)"
label var 	nearest_town_distance_km 		"Distance to Nearest Town (km)"
label var 	nearest_town 					"Nearest Town"
label var 	community_illiterate 			"Regional Illiteracy Rate (pct)"
label var 	community_spanish 				"Regional Spanish Fluency Rate (pct)"
label var 	community_houses_electricity 	"Households with Electricty (pct)"
label var 	community_houses_tv 			"Households with TV (pct)"
label var 	community_houses_car 			"Households with an Automobile (pct)"
label var 	community_houses_cellphone 		"Households with a Cellphone (pct)"
label var 	community_houses_internet		"Households with Internet Access (pct)"

foreach y of varlist community_* {
	replace `y' = `y' * 100 if `y' <= 1
}

save 		"$work_dir/survey_location_points.dta", 			replace


** Merge data with survey.

use 		"$work_dir/encuesta_miel.dta", 						clear

merge 		m:1 	region_survey 	using "$work_dir/survey_location_points.dta"
rename 		date								survey_date

save 		"$work_dir/encuesta_miel.dta",						replace 

