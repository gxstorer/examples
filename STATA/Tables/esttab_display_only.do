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
****                          Make Tables                                   ****
****                                                                        ****
********************************************************************************

** Table 1
** Summary Stats of sub categories within "Foreign" variable (Foreign vs. Domestic), displaying means and standard deviation in seperate columns.
	
	eststo 		clear	
	eststo: 	estpost tabstat price, by(foreign) statistics(mean sd) nototal

	esttab 		, title("Car prices: Domestic vs. Foreign") cells("mean(fmt(%7.1f)) sd(fmt(%7.1f))") noobs compress
	eststo 		clear		


** Table 2
** Summary Stats of sub categories within "Foreign" variable (Foreign vs. Domestic), displaying means and standard deviation in the same column.

	eststo 		clear	
	eststo: 	estpost tabstat price, by(foreign) statistics(mean sd) nototal

	esttab 		, title("Car prices: Domestic vs. Foreign") cells(mean(fmt(%7.1f)) sd(fmt(%7.1f))) noobs compress 																				
	eststo 		clear		

// Only difference between Table 1 & Table 2 is removing the quotations affects the shape of the data.

** Table 3
**
