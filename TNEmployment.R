rm(list = ls())
library("stats")
library("ggplot2")


tsbr = read.csv("FilteredTSBR.csv")
#my file reads number as $123,456.78 -> $123456.78 -> 123456.78
#https://stat.ethz.ch/pipermail/r-help/2010-May/237909.html
#http://stackoverflow.com/questions/1523126/how-to-read-a-csv-file-in-r-where-some-numbers-contain-commas
tsbr$Salary.semester = as.numeric(sub('$', '', as.character(gsub(",", "", as.character(tsbr$Salary.semester))), fixed = TRUE))

nintyninePercent = quantile(tsbr$Salary.semester, 0.99)
NNJobs = subset(tsbr, Salary.semester > nintyninePercent)
NNJobs$department
NNJobs$FullName = paste(NNJobs$First.Name, NNJobs$last.name)

ggplot(aes(x = as.character(department), y = Salary.semester), data = NNJobs) +
  geom_point() +
  facet_wrap(~Institution.Name)

ggsave(filename = "Salary.png")
ggplot() + aes(x = NNJobs$department) + geom_histogram()
summary(NNJobs$Salary.semester)

as.character(NNJobs$department)

medical = c("OB GYN", "Surgery", "Psychiatry", "Family Medicine",
          "Pediatrics", "Vice Pres for Health Affairs", "Family Practice Resid Kpt",
          "Dean College of Pharmacy", "Internal Medicine", "Family Practice Resid Johnson City",
          "Biomedical Sciences", "Dean College of Medicine", "Family Medicine                       .",
          "Pediatrics", "Psychology", "Pathology", "Health Sciences")

administration = c("Provost  VP Academic Affairs", "Presidents Office", "Office of the Provost",
                 "Management", "Vice President for Finance and Adm", "Office of Graduate Medical Educ",
                 "Office of Sponsored Programs", "Assoc Dean Academic Affairs", "VP University Advancement",
                 "University Provost", "Office of Senior Vice President", "VP Student Affairs",
                 "Graduate Programs", "Bureau Business Economic Research", "Office of President",
                 "Chair of Excellence Free Enterprise", "Ofc VP Research & Economic Dev", "Provost  VP Academic Affairs",
                 "Office of the President", "Research and Spons Programs", "President's Office", "Vice President Research", "Provost Office")

sports = c("Football", "Athletic Administration", "Office of Intercoll Athletics", "Mens Basketball",
         "Womens Basketball", "Athletic Director", "Football Regular Season", "Basketball Men",
         "Basketball Women", "Men's Basketball", "Athletics Director", "Athletic Business Office")

stem = c("Dean of Engineering Admin Office", "Mechanical Engineering", "Dean Basic and Applied Sciences",
       "Biomedical Engineering", "Management Information Systems", "College of Engineering",
       "Information Technology Division", "Math B Bollobas")

buisness = c("Dean College Of Business", "College of Business Economics", "Finance Insurance Real Estate",
           "School of Accountancy", "School Hospitality and Resort Mgmt", "Dean Mass Communication")

liberalArts = c("Philosophy", "College of Arts and Sciences")
is.na(tsbr$fte)
law = c("School of Law")
NNJobs$deptBucket[which(NNJobs$department %in% administration)] = "Administration"
NNJobs$deptBucket[which(NNJobs$department %in% medical)] = "Medical"
NNJobs$deptBucket[which(NNJobs$department %in% sports)] = "Sports"
NNJobs$deptBucket[which(NNJobs$department %in% stem)] = "STEM"
NNJobs$deptBucket[which(NNJobs$department %in% buisness)] = "Buisness"
NNJobs$deptBucket[which(NNJobs$department %in% liberalArts)] = "Liberal Arts"
NNJobs$deptBucket[which(NNJobs$department %in% law)] = "Law"

NNJobs$deptBucket
is.na(NNJobs$deptBucket)
ggplot(aes(x = deptBucket, y = Salary.semester), data = NNJobs) +
  geom_point() +
  facet_wrap(~Institution.Name)
