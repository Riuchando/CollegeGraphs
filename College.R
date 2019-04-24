rm(list = ls())

library("ggplot2")
uncleaned <- read.csv("DataMunged.csv")

# adjust for inflation since Yale
uncleaned$Yale.inflation.not.taken.into.account. = uncleaned$Yale.inflation.not.taken.into.account. * (uncleaned$Interest.rate + 1)
# update the numbers based on the Harvard Numbers
indexof05 = match(2005, uncleaned$Year)
# misread some info when munging, to fix
uncleaned$Harvard.based.on.2007. = uncleaned$Harvard.based.on.2007. * (uncleaned$Interest.rate[indexof05] + 1)

# sorry for verbose, proably will write to clean file
uncleaned$Minimum.Wage.in.2012.Dollars = as.numeric(gsub("\\$", "", uncleaned$Minimum.Wage.in.2012.Dollars)) *
  (uncleaned$Interest.rate[match(2012, uncleaned$Year)] + 1)

# copied and pasted some fields with numbers that had commas in the numbers
uncleaned$Public.Education..2013. = as.numeric(gsub(",", "", uncleaned$Public.Education..2013.))
uncleaned$Private.Education..2013. = as.numeric(gsub(",", "", uncleaned$Private.Education..2013.))
uncleaned$Minimum.Wage.in.2012.Dollars * 40 * 52
# plotting the raw values
png("1976-2013.png")
ggplot(data = uncleaned, aes(Year)) +
  geom_line(aes(y = Harvard.based.on.2007.), colour = "red") +
  geom_line(aes(y = Yale.inflation.not.taken.into.account.), colour = "blue") +
  geom_line(aes(y = Public.Education..2013.), colour = "#CCA352") +
  geom_line(aes(y = Private.Education..2013.), colour = "purple") +
  geom_line(aes(y = Minimum.Wage.in.2012.Dollars * 40 * 26), colour = "green") +
  labs(title = "1976-2013 tuition cost per semester", y = "Money adjusted for inflation", x = "year")
dev.off()

uncl <- read.csv("1964Data.csv")
# update the numbers based on the Harvard Numbers
indexof05 = match(2005, uncl$Year)
# misread some info when munging, to fix
# uncl$Interest.Rate
uncl$Harvard.based.on.2007. = uncl$Harvard.based.on.2007. * (uncl$Interest.Rate[indexof05] + 1)
uncl$Minimum.Wage.in.2012.Dollars = as.numeric(gsub("\\$", "", uncl$Minimum.Wage.in.2012.Dollars)) *
  (uncl$Interest.Rate[match(2012, uncl$Year)] + 1)
uncleaned$Harvard.based.on.2007. = uncleaned$Harvard.based.on.2007. * (uncleaned$Interest.rate[indexof05] + 1)

# sorry for verbose, proably will write to clean file
uncleaned$Minimum.Wage.in.2012.Dollars = as.numeric(gsub("\\$", "", uncleaned$Minimum.Wage.in.2012.Dollars)) *
  (uncleaned$Interest.rate[match(2012, uncleaned$Year)] + 1)

# copied and pasted some fields with numbers that had commas in the numbers
uncl$Public.Education..2013. = as.numeric(gsub(",", "", uncl$Public.Education..2013.))
uncl$Private.Education..2013. = as.numeric(gsub(",", "", uncl$Private.Education..2013.))
# replotting values, include "Hard Worker"
png("1964-2013.png")

realpercen = ((uncl[2013 - 1963, 5] * 4 - uncl[1978 - 1963, 5] * 4) / (uncl[1978 - 1963, 5] * 4)) + 1
# 112*(uncl[1978-1963,5]*4) -(uncl[1978-1963,5]*4)
(realpercen + 1) * uncl[1978 - 1963, 5] - uncl[1978 - 1963, 5]
((12.2 * uncl[1978 - 1963, 5]) - uncl[1978 - 1963, 5]) / 2
HarvGrow = ((uncl[2013 - 1963, 3] * 4 - uncl[1978 - 1963, 3] * 4) / (uncl[1978 - 1963, 3] * 4)) + 1

ggplot(data = uncl, aes(Year)) +
  geom_line(aes(y = Harvard.based.on.2007.), colour = "red") +
  geom_line(aes(y = Public.Education..2013.), colour = "#CCA352") +
  geom_line(aes(y = Private.Education..2013.), colour = "purple") +
  geom_line(aes(y = Minimum.Wage.in.2012.Dollars * 40 * 26), colour = "green") +
  geom_line(aes(y = Minimum.Wage.in.2012.Dollars * 60 * 26), colour = "cyan") +
  labs(title = "1964-2013 tuition cost per semester", y = "Money adjusted for inflation", x = "Year")
dev.off()

avgPerson = uncl$Minimum.Wage.in.2012.Dollars * 40

# how many full work weeks would it take the average person 
png("avgperson.png")
ggplot(data = uncl, aes(Year)) +
  geom_line(aes(y = Harvard.based.on.2007. / avgPerson), colour = "red") +
  geom_line(aes(y = Public.Education..2013. / avgPerson), colour = "#CCA352") +
  geom_line(aes(y = Private.Education..2013. / avgPerson), colour = "purple") +
  labs("1964-2013 How many weeks to work at minimum wage to pay for semester", y = "weeks to pay for semester", x = "Year")
dev.off()
# let's suppose that this person works 20 hours in the school year (28 weeks), 60 hours in the summer(24 weeks)
realPerson = uncl$Minimum.Wage.in.2012.Dollars * 60 * 24 + uncl$Minimum.Wage.in.2012.Dollars * 20 * 28
# how many full work weeks would it take the average person 
png("fulltime.png")
ggplot(data = uncl, aes(Year)) +
  geom_line(aes(y = Harvard.based.on.2007. / realPerson), colour = "red") +
  geom_line(aes(y = Public.Education..2013. / realPerson), colour = "#CCA352") +
  geom_line(aes(y = Private.Education..2013. / realPerson), colour = "purple") +
  labs("1964-2013 How many years to pay for a semester ", y = " <0.5 means it's possible", x = "Year")
dev.off()
# next question how much money would the Real person need to make an hour to pay for college without scholarships?
# 1*60*24 + 1*20*28 = 2000, this person works 2000 hours, so lets divide that
colors = c("red", "#CCA352", "purple")
png("properWage.png")
ggplot(data = uncl, aes(Year)) +
  geom_line(aes(y = Harvard.based.on.2007. / 1000), colour = "red") +
  geom_line(aes(y = Public.Education..2013. / 1000), colour = "#CCA352") +
  geom_line(aes(y = Private.Education..2013. / 1000), colour = "purple") +
  labs(title = "What would you need to make to pay for college", y = "amount of $ given 2000 hrs/year", x = "year")
dev.off()




# calculating cost of living
# 1964-2009
# http://www.davemanuel.com/2010/12/30/historical-gas-prices-in-the-united-states/
gas = c(1.55, 1.57, 1.57, 1.57, 1.53, 1.51, 1.47, 1.43, 1.36, 1.38, 1.74, 1.69, 1.73, 1.74, 1.66, 2.06, 2.61, 2.64, 2.34, 2.15, 2.03, 1.95, 1.47, 1.46, 1.41, 1.47, 1.61, 1.53, 1.47, 1.42, 1.39, 1.41, 1.48, 1.46, 1.24, 1.34, 1.7, 1.61, 1.47, 1.69, 1.94, 2.3, 2.51, 2.64, 3.01, 2.14)
gas = gas * (uncl$Interest.Rate[match(2009, uncl$Year)] + 1)
# these were obtained from google
g2010 = 3.00 * (uncl$Interest.Rate[match(2010, uncl$Year)] + 1)
g2011 = 3.41 * (uncl$Interest.Rate[match(2011, uncl$Year)] + 1)
g2012 = 3.51 * (uncl$Interest.Rate[match(2012, uncl$Year)] + 1)
g2013 = 3.49 * (uncl$Interest.Rate[match(2013, uncl$Year)] + 1)
gas = c(gas, g2010, g2011, g2012, g2013)

# average mpg from 1980-2013
# http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_statistics/html/table_04_23.html
mpg = c(16.0, 17.5, 20.3, 21.2, 21.0, 20.6, 20.8, 21.1, 21.2, 21.5, 21.6, 21.4, 21.9, 22.1, 22.0, 22.2, 22.5, 22.1, 22.5, 22.9, 23.7, 23.5, 23.3, 23.2, 23.3, 23.4)

# saving data for Ken
uncl$minWage = uncl$Minimum.Wage.in.2012.Dollars
uncl$Minimum.Wage.in.2012.Dollars = NULL
uncl$Harvard = uncl$Harvard.based.on.2007.
uncl$Harvard.based.on.2007. = NULL
uncl$avgPrivate = uncl$Private.Education..2013.
uncl$Private.Education..2013. = NULL
uncl$avgPublic = uncl$Public.Education..2013.
uncl$Public.Education..2013. = NULL
cleaned = cbind(uncl, gas)
write.csv(cleaned, file = "cleaned.csv")
