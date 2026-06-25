import urllib.request
import json
import os

def fetch_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    response = urllib.request.urlopen(req)
    return json.loads(response.read().decode('utf-8'))

print("Fetching data...")
provinces = fetch_json('https://raw.githubusercontent.com/NorakGithub/cambodia-gazetteer/main/provinces.json')
districts = fetch_json('https://raw.githubusercontent.com/NorakGithub/cambodia-gazetteer/main/districts.json')
communes = fetch_json('https://raw.githubusercontent.com/NorakGithub/cambodia-gazetteer/main/communes.json')

# Build the map
# provinces: list of { "code": "01", "english": "Banteay Meanchey", ... }
# districts: list of { "code": "0102", "english": "Mongkol Borei", "province_id": ..., "province_code": "01", ... }
# communes: list of { "code": "010201", "english": "Banteay Neang", "district_id": ..., "district_code": "0102", ... }

prov_map = { p['code']: p['english'] for p in provinces }
dist_map = {}
for d in districts:
    prov_code = d['code'][:2]
    if prov_code not in dist_map:
        dist_map[prov_code] = {}
    dist_map[prov_code][d['code']] = d['english']

comm_map = {}
for c in communes:
    dist_code = c['code'][:4]
    if dist_code not in comm_map:
        comm_map[dist_code] = []
    comm_map[dist_code].append(c['english'])

# Assemble nested dict: Province -> District -> List[Commune]
final_map = {}
for p_code, p_name in prov_map.items():
    final_map[p_name] = {}
    if p_code in dist_map:
        for d_code, d_name in dist_map[p_code].items():
            final_map[p_name][d_name] = comm_map.get(d_code, [])

print("Writing dart file...")
dart_content = "// AUTO GENERATED - CAMBODIA LOCATION DATA\n\n"
dart_content += "const Map<String, Map<String, List<String>>> kCambodiaLocations = "
dart_content += json.dumps(final_map, ensure_ascii=False, indent=2)
dart_content += ";\n"

# We must replace JSON brackets with Dart map/list brackets if necessary, 
# but valid JSON object string is valid Dart map string as long as we use double quotes.
# Wait, json.dumps creates double quotes keys/values which is valid Dart.
# However, json.dumps uses `null` but we don't have nulls here.

output_path = os.path.join('lib', 'core', 'constants', 'location_data.dart')
with open(output_path, 'w', encoding='utf-8') as f:
    f.write(dart_content)

print("Done!")
