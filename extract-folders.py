
import requests
from bs4 import BeautifulSoup
import sys

def extract_all_links(site):
    html = requests.get(site).text
    soup = BeautifulSoup(html, 'html.parser').find_all('a')
    links = [link.get('href') for link in soup]
    return links

result = []

# get site_link as a first argument
site_link = sys.argv[1]

try:
    all_links = extract_all_links(site_link)

    # remove following links from the list: "/", "?C=N;O=D", "?C=M;O=A", "?C=S;O=A", "?C=D;O=A", "?C=N;O=A"
    for link in all_links:
        if link not in ["/", "?C=N;O=D", "?C=M;O=A", "?C=S;O=A", "?C=D;O=A", "?C=N;O=A"]:
            result.append(link)

    # print all links as a JSON array
    print(result)
except:
    print("Invalid site link!")
    sys.exit()
