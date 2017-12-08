
# US Frequent Poverty Measure
This repository contains code for a monthly US Frequent Poverty Measure based on the CPS (Current Population Survey). It contains scripts to download the most recent data and create figures showing the frequent poverty rate. 

It is the product of some work by contributors at the Stanford Center on Poverty and Inequality including Koji Chavez, Charles Varner, Marybeth Mattingly, and Giovanni Righi. 

<div style="text-align:center">
![](https://raw.githubusercontent.com/grighi/fpm/master/output_100.png "most recent version")
</div>

### Building

The project builds with bash, Stata, [git](https://git-for-windows.github.io/), [Python3.6](https://www.python.org/downloads/), and [R](https://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-R-be-installed_003f). From a Unix shell:

```
# from directory where you want to place the project:
git clone https://github.com/grighi/fpm.git

# pip should be in your python installation, but it needs upgrading. On Linux/mac OSX:
pip install -U pip
# or on windows:
python -m pip install -U pip
# note that if you had Python 2.7 on your computer you may need to run this all with "pip3" instead of "pip"

# now with pip, install BeautifulSoup for downloading:
pip install bs4

# [user edits this!] add stata location to your path:
export PATH=$PATH:/Applications/Stata/Stata.app/Contents/MacOS/Stata

cd fpm
./portable_build.sh
```
#### Additions
* Abadie and Imbens have [written](https://economics.mit.edu/files/13159) about a martingale representation of matching estimators of which one example is hot-deck imputation. Can we use this to justify that our estimate should converge?

