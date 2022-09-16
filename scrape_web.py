#!/bin/python3

import requests, json
from bs4 import BeautifulSoup
from dateutil import parser
from tabulate import tabulate

def date_util(str):
    dt = parser.parse(str)

    ret = dt.ctime()
    return ret

def pretty_2dlist(lst):
    """
    Pretty Prints 2D List
    """
    print(tabulate(lst, tablefmt="github"))



def get_clist_data():
    URL = 'https://clist.by/'
    r = requests.get(URL)
    soup = BeautifulSoup(r.text, 'html.parser')
    data_ace = soup.select('.coming .data-ace')
    # data_ace = soup.select('.data-ace') # For all contest
    # Get data-ace attribute from <a> tag
    data_ace = [ e['data-ace'] for e in data_ace]
    data_ace = [ json.loads(e) for e in data_ace]
    tbl = []
    attrs = ['location', 'time' ]
    location_filter = ['codechef.com', 'atcoder.jp', 'codeforces.com', 'leetcode.com']

    data_ace = list(filter(lambda e : e['location'] in location_filter, data_ace))

    for entry in data_ace:
        row = []
        for attr in attrs:
            # for handline Time
            if 'time' == attr:
                start = date_util(entry['time']['start'])
                end = date_util(entry['time']['end'])
                row.append(start)
                row.append(end)
                continue

            row.append(entry[attr])
        tbl.append(row)

    # Print Table
    headers = ['Location', 'Start Time', 'End Time']
    tbl.insert(0, headers)
    pretty_2dlist(tbl)



def main():
    """
    main function
    """
    get_clist_data()

if __name__ == '__main__':
    main()
