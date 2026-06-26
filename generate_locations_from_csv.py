import urllib.request
import csv
import json
import os
import io

def fetch_csv(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    response = urllib.request.urlopen(req)
    content = response.read().decode('utf-8-sig')
    return list(csv.DictReader(io.StringIO(content)))

print("Fetching CSV data...")
provinces = fetch_csv('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaProvinceList2023.csv')
districts = fetch_csv('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaDistrictList2023.csv')
communes = fetch_csv('https://raw.githubusercontent.com/bsthen/CambodiaGeoAPI/main/data/CambodiaCommuneList2023.csv')

print("Provinces headers:", provinces[0].keys())
print("Districts headers:", districts[0].keys())
print("Communes headers:", communes[0].keys())

prov_map = {}
for p in provinces:
    code = p.get('code', '')
    name = p.get('name_en', '').strip()
    if code and name:
        prov_map[code] = name

dist_map = {}
for d in districts:
    p_code = d.get('province_code', '')
    d_code = d.get('code', '')
    name = d.get('name_en', '').strip()
    if p_code and d_code and name:
        if p_code not in dist_map:
            dist_map[p_code] = {}
        dist_map[p_code][d_code] = name

comm_map = {}
for c in communes:
    d_code = c.get('district_code', '')
    name = c.get('name_en', '').strip()
    if d_code and name:
        if d_code not in comm_map:
            comm_map[d_code] = []
        comm_map[d_code].append(name)

final_map = {}
for p_code, p_name in prov_map.items():
    final_map[p_name] = {}
    if p_code in dist_map:
        for d_code, d_name in dist_map[p_code].items():
            final_map[p_name][d_name] = comm_map.get(d_code, [])

dart_content = "// AUTO GENERATED - CAMBODIA LOCATION DATA\n\n"
dart_content += "const Map<String, Map<String, List<String>>> kCambodiaLocations = "
dart_content += json.dumps(final_map, ensure_ascii=False, indent=2)
dart_content += ";\n"

output_path = os.path.join('lib', 'core', 'constants', 'location_data.dart')
with open(output_path, 'w', encoding='utf-8') as f:
    f.write(dart_content)

print("Done generating location_data.dart")
