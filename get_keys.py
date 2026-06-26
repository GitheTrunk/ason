import urllib.request, csv, io, json
def head(url):
    c = urllib.request.urlopen(url).read().decode('utf-8-sig')
    return list(csv.DictReader(io.StringIO(c)))[0].keys()

with open('keys.json', 'w') as f:
    json.dump({
        'p': list(head('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaProvinceList2023.csv')),
        'd': list(head('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaDistrictList2023.csv')),
        'c': list(head('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaCommuneList2023.csv'))
    }, f)
