
use 	"$work_dir/miel_panel.dta" 		, 	clear

* Rename variables *************************************************************

rename 	(clave 	meses 	total_ganancia 		comunidad edad 	miembros 		mayores 		menores 		venta 		otra_milpa_ingresos otra_trabajado_ingresos) /// 
		(id 	months 	total_game_earnings community_raw age 	family_members 	family_older 	family_younger 	income_farm income_other_farm 	income_other_work)

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

* Rename months	****************************************************************
	
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
