from serpapi import GoogleSearch

destination_cities = ['Los Angeles', 'San Francisco', 'Sacramento', 'San Jose', 'Oakland',
                      'Anaheim', 'Fresno', 'Long Beach', 'Santa Monica', 'San Diego']

common_params = {
    "engine": "google_maps_directions",
    "api_key": "668089e225ed59d57386d1df1d4f81b222afc963a4a3a1fb816f3997278d33e9",
    "travel_mode": "0"
}

travel_time = [[0] * len(destination_cities) for _ in range(len(destination_cities))]

for i, city1 in enumerate(destination_cities):
    common_params["start_addr"] = f"{city1}, USA"

    for j, city2 in enumerate(destination_cities):
        common_params["end_addr"] = f"{city2}, USA"

        if city1 == city2:
            travel_time[i][j] = 0
            continue
        try:
            search = GoogleSearch(common_params)
            results = search.get_dict()
            directions = results.get("directions", [])
            if directions:
                travel_time[i][j] = round(int(directions[0]['duration'])/60/60, 2)
                print(directions)
            else:
                travel_time[i][j] = float('inf')

        except Exception as e:
            print(f"Error processing request for {city1} to {city2}: {e}")
            travel_time[i][j] = float('inf')

for row in travel_time:
    print(row)



