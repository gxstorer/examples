clear

**ssc install schemepack
**ssc install estout

	set scheme cblind1


********************************************************************************
****                                                                        ****
****                        	 Get Data                                   ****
****                                                                        ****
********************************************************************************

	webuse set 	"https://github.com/gxstorer/examples/raw/refs/heads/main/STATA/Data%20Cleaning/"
	webuse 		auto_practice.dta, 		clear									// This is a link to a altered version of the locally-stored STATA dataset "auto.dta".

** Alternative dataset															// If having issues with online sourcing, remove the "//" in the next line to use the following code to get the original dataset.
//	sysuse 		auto, 		clear 												// Note, this dataset doesn't have data input error examples like in the auto_practice.dta.


********************************************************************************
****                                                                        ****
****                        	 View Data                                  ****
****                                                                        ****
********************************************************************************

	describe																	// Describe just provides an overview of what the dataset is comprised of: how many variables, what format they are in, and number of observations.

	codebook, 	compact															// Codebook (compact) is a concise way to view summary statistics of all variables without taking up too much space. 
																				// This is also a good way to spot glaring issues in the data, especially outliers. Look at "price". The min/max values appear to be incorrect.
																				// The min price is 6.295, which isn't a reasonable price for a car. Likewise, the max is 145000, which is 19x the mean value.
																				
	codebook 	price															// Codebook combines summary and tabular data.
																				// You can leave variable blank, but will probably display too much data to be practical to view. Also used to spot missing values.
																				// By looking just at price, we can see if the min/max values resemble the rest of the data or are possible outliers.
																				// the 10th percentile price is 3,799, while the 90th percentile is 11,385. These appear to be outliers.

	graph 		hbox price														// The to visually display the data of a single variable, a boxplot of the interquartile range (IQR) of that variable.
																				// Notice how stretched out the data is? We can't see much of the box since something is well beyond the rest of the data.																																						

** List vs. Browse																// To understand more about these outliers, we need to isolate the data that we're interested in. There are two main commands regarding viewing data:
																				// "list" command will display data within the command window.
																				// "browse" command will reshape the data browser based on the criteria you set.
								
																				// If we wanted to isolate the data to only look at the following variables: make price mpg foreign, for observations that are above that 90th
																				// percentile in price within our data, we can do that both in list or browse:
	list 	make price mpg foreign 		if price > 11385
	browse 	make price mpg foreign 		if price > 11385
																				// If you're just looking a select bit of data, the list command is probably more convenient. But if it's a large set of data, then use browse. 
																				// By selecting this data, we can see that the 145000 is a clear outlier. a quick hypothesis is that it was a data entry error with an incidental
																				// additional "0" entered.

	

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
	
********************************************************************************
****                                                                        ****
****                    	Destringing Data                                ****
****                                                                        ****
********************************************************************************	
	
	split 		make, 		gen(make_)
	encode 		make_1, 	gen(brand)
	replace 	make_2 	= 	make_2 + make_3
	drop 		make_3
	encode 		make_2, 	gen(model)
	