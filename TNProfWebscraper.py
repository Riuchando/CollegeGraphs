import requests
import bs4
from urllib2 import urlopen
import unicodecsv
import csv

webUrl = "https://www.tbr.edu/hr/salaries"
colnames = ["Institution Name", "last name", "First Name",
            "Job title", "department", "Salary/semester", "Fte"]


def webscrape(collegename, pagelength):
    initialPage = webUrl+"?firstname=&lastname=&department=&jobtitle=&institution=" + \
        "+".join(collegename.split())
    # print initialPage
    response = requests.get(initialPage, verify=False)
    # response = requests.get(webUrl, verify= False)
    soup = bs4.BeautifulSoup(response.text, 'html.parser')
    # print(soup.prettify())
    # doesn't work as expected-for future reference on what is expected
    # fieldentries = soup.find_all("td", {"class" : "views-field views-field-institution-1",
    #                                    "class" : "views-field views-field-lastname",
    #                                    "class" : "views-field views-field-firstname",
    #                                    "class" : "views-field views-field-jobtitle",
    #                                    "class" : "views-field views-field-department",
    #                                    "class" : "views-field views-field-php",
    #                                   "class" : "views-field views-field-fte"})
    # there is a special case for the first page of the webscraper
    data = []
    data = data+parseTable(soup)
    for integer in range(pagelength):
        subsequentPages = webUrl+"?firstname=&lastname=&department=&jobtitle=&institution=" + \
            "%20".join(collegename.split())+"&page="+str(integer)
        print subsequentPages
        response = requests.get(subsequentPages, verify=False)
        soup = bs4.BeautifulSoup(response.text, 'html.parser')
        data = data+parseTable(soup)
    return data


def parseTable(soup):
    # http://stackoverflow.com/questions/23377533/python-beautifulsoup-parsing-table
    table = soup.find(
        'table', attrs={"class": "views-table sticky-enabled cols-7"})
    # I should probably make the data later
    # headers = [ header.text for header in table.find_all('th')]
    table_body = table.find('tbody')
    data = []
    rows = table_body.find_all('tr')
    for row in rows:
        cols = row.find_all('td')
        cols = [ele.text.strip() for ele in cols]
        # print cols
        data.append([ele for ele in cols if ele])

    return data


def main():
    webscraped = []
    webscraped = webscrape("TN Technological Univ", 23)
    # instead of append: http://stackoverflow.com/questions/11574195/how-to-merge-multiple-lists-into-one-list-in-python
    webscraped = webscraped + webscrape("Austin Peay State University", 24)
    webscraped = webscraped + webscrape("East Tennessee State Univ", 45)
    webscraped = webscraped + webscrape("Middle TN State University", 43)
    webscraped = webscraped + webscrape("Tennessee State University", 26)
    webscraped = webscraped + webscrape("University of Memphis", 48)

    writeCsv(webscraped)


def writeCsv(data):
    with open("FilteredTSBR.csv", "w") as outfile:
        # note this is janky because I use python 2.x primarily and it's default csv writer doesn't use unicode
        # so just incase there's a teacher/employee who decides to use an umlaut, then I can just do that
        writer = unicodecsv.writer(
            outfile, quoting=csv.QUOTE_ALL, encoding='utf-8')
        writer.writerow(colnames)
        for line in range(len(data)):
            # print data[line]
            writer.writerow(data[line])
        print "Done Processing to file"


if __name__ == '__main__':
    main()
