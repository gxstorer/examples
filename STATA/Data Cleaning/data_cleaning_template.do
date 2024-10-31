clear

**ssc install schemepack
**ssc install estout

	set scheme cblind1


********************************************************************************
****                                                                        ****
****                        	 Get Data                                   ****
****                                                                        ****
********************************************************************************

	sysuse 		auto, 		clear

********************************************************************************
****                                                                        ****
****                        	 Edit Data                                  ****
****                                                                        ****
********************************************************************************

** Splitting string variables													// To split up a variable the split command will create a new variable at every break within the string.	
	split 		make, 		gen(make_)

** encoding categorical string variable into numerical.							// For categorical data, it's beneficial to have the string description of the category while still having a numerical value attached to it.
	encode 		make_1, 	gen(brand)
	replace 	make_2 	= 	make_2 + make_3										
	drop 		make_3
	encode 		make_2, 	gen(model)											// This results in an encoded version of both the make and model in the dataset.
	
** Destring and Tostring variables.

	tostring 	mpg, 		replace												
	destring 	mpg, 		replace force 

********************************************************************************
****                                                                        ****
****                        	 View Data                                  ****
****                                                                        ****
********************************************************************************

	describe																	// Describe just provides an overview of what the dataset is comprised of: how many variables, what format they are in, and number of observations.

	codebook, compact															// Codebook (compact) is a concise way to view summary statistics of all variables without taking up too much space. 
	codebook price																// Codebook combines summary and tabular data.
																				// You can leave variable blank, but will probably display too much data to be practical to view.
																																							
** List vs. Browse
																				// List command will display data within the command window, while browse reshapes the data browser.
																				// Observe that the same type of data will be displayed in both of these commands:

	list 	make price mpg foreign 		if rep78 == 5
	browse 	make price mpg foreign 		if rep78 == 5
	

** Viewing data based on missing data of a given variable.

																				// If you want to look at all the data but only look at the observations with missing data in a specified variable (or variables),
																				// it might be better to use the browse command, since you'll have the horizontal scrolling function in the browser.


	browse if missing(rep78 )													// Notice that no variables are being specified to view, which STATA reads as "all variables."
	browse if missing(rep78) & missing(price)									// Demonstration of if you wanted multiple criteria.


********************************************************************************
****                                                                        ****
****                        	 Duplicates                                 ****
****                                                                        ****
********************************************************************************

	duplicates list 															// If left unspecified, will look through all variables for any duplicates.
	duplicates list price 														// This will look specifically at the price variable.
	duplicates drop 			, force											