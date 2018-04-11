
# US Frequent Poverty Measure
This repository contains code for a monthly US Frequent Poverty Measure based on the CPS (Current Population Survey). It contains scripts to download the most recent data and create figures showing the frequent poverty rate. 

It is the product of some work by contributors at the Stanford Center on Poverty and Inequality including Koji Chavez, Charles Varner, Marybeth Mattingly, and Giovanni Righi. 

<div style="text-align:center">
  <img src="https://raw.githubusercontent.com/grighi/fpm/master/output_100.png"></img>
</div>

### Building

To build the project, make sure you have all the necessary software (Stata, [git](https://git-for-windows.github.io/), [Python3.6](https://www.python.org/downloads/), and [R](https://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-R-be-installed_003f)) and open a shell:

```
# from directory where you want to place the project:
git clone https://github.com/grighi/fpm.git

# make sure Stata is installed and on your path, something like:
export PATH=$PATH:/Applications/Stata/Stata.app/Contents/MacOS/Stata

# run the build script
cd fpm
./linux_build.sh
```
#### Additions
* Abadie and Imbens have [written](https://economics.mit.edu/files/13159) about a martingale representation of matching estimators of which one example is hot-deck imputation. Can we use this to justify that our estimate should converge?

