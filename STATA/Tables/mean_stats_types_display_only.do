* Summary stats: price mean & SD between foreign and domestic cars.


* mean *************************************************************************

mean price, over(foreign)
ereturn list
esttab
// This creates the overall intended result, but when looking at the stored estimates, the variable labels are these odd generated labels of "c.price@foreign"
// But we do easily get the matrices of interest with e(b) & e(se)

* statsby **********************************************************************

statsby mean=r(mean) sd=r(sd), by(foreign):  summarize price
// Works similar to a collapse command, in that it runs the given calculation and converts the dataset into statistics desired.
// Problem is that it doesn't produce any r-return or e-return matrices, and will have to manually create your own matrix.


* tabulate *********************************************************************

tab foreign, sum(price)

// Achieves the same result, but does not have a straightforward path to storing results. (typically the option "matcell" would be used here, but doesn't appear to be compatible when using the summarize option)

* estpost **********************************************************************

eststo:  estpost ttest price , by(foreign) unequal
ereturn list
// This creates a nice list of scalars, but we only have standard errors and not standard deviations.

* tabstat **********************************************************************

tabstat price, by(foreign) statistics(mean sd) save
return list

// Now we're getting something useful. The save option stores results as r-matrices.


* estpost tabstat **************************************************************

eststo: estpost tabstat price, by(foreign) statistics(mean sd) nototal
ereturn list

// Using the estimates store and estpost commands along with the tabstat produces even cleaner stored values that display the e-results in the table.


* estpost tabstat vs. tabstat **************************************************

// estpost creates ereturn matrices, while tabstat is rreturn matrices. 

// The stats matrix labels and shape are different. estpost is column based, e.g. "mean" & "SD". While tabstat is variable row based, e.g. "domestic" "foreign": 
// estpost: [1,n] e(Mean), e(SD)
// tabstat: [n,1] r(stat1), r(stat2) 

// estpost doesn't have variable scalars, while tabstat does:
// tabstat: r(name1) ...


