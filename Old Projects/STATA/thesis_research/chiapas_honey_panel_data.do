use 		"$work_dir/encuesta_miel.dta", 		clear

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