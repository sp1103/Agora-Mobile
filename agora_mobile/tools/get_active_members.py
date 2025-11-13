import requests
import json
import os

API_KEY = "8UBZO8vs7QIrZjlErsOO7PX9Kap1J3HHterlY6qa"  # Insert your Congress API key

CONGRESS_YEAR = {
    115: 2017,
    116: 2019,
    117: 2021,
    118: 2023,
    119: 2025,
}

def get_session_range(congress, session):
    """Get the year range for a specific congress session."""
    start_year = CONGRESS_YEAR[congress]
    if session == 1:
        return start_year, start_year
    elif session == 2:
        return start_year + 1, start_year + 1
    else:
        raise ValueError("Session must be 1 or 2")

def fetch_all_members(congress):
    """Fetch all members for a given congress with pagination."""
    all_members = []
    offset = 0
    
    while True:
        url = f"https://api.congress.gov/v3/member/congress/{congress}"
        params = {"api_key": API_KEY, "limit": 250, "offset": offset}
        
        print(f"Fetching members with offset {offset}...")
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        
        members = data.get("members", [])
        if not members:
            break
        
        all_members.extend(members)
        offset += 250
    
    print(f"Total members fetched: {len(all_members)}")
    return all_members

def fetch_member_details(bio_id):
    """Fetch detailed member info including all terms with districts."""
    url = f"https://api.congress.gov/v3/member/{bio_id}"
    params = {"api_key": API_KEY}
    
    response = requests.get(url, params=params)
    response.raise_for_status()
    data = response.json()
    
    return data.get("member", {})

def filter_active_members(members, session_start, session_end, congress):
    """Filter members active during the session, keeping only the most recent holder of each seat."""
    house_seats = {}
    senate_seats = {}
    
    print(f"\nFiltering for session years {session_start}-{session_end}")
    print(f"Fetching detailed member info (this may take a while)...")
    
    for idx, m in enumerate(members):
        if (idx + 1) % 50 == 0:
            print(f"  Processing member {idx + 1}/{len(members)}...")
        
        bio_id = m.get("bioguideId", "")
        if not bio_id:
            continue
        
        # Get basic info from list (includes party!)
        name = m.get("name", "")
        member_state = m.get("state", "")
        party_name = m.get("partyName", "")  # This is available in the list!
        
        if not member_state:
            continue
        
        # Fetch detailed member info to get terms with districts
        try:
            member_details = fetch_member_details(bio_id)
        except Exception as e:
            print(f"  Error fetching details for {bio_id}: {e}")
            continue
        
        # Get terms with proper structure
        terms_data = member_details.get("terms", {})
        if isinstance(terms_data, dict):
            term_list = terms_data.get("item", [])
        elif isinstance(terms_data, list):
            term_list = terms_data
        else:
            term_list = []
        
        for term in term_list:
            # Check if this term is for the target congress
            term_congress = term.get("congress")
            if term_congress != congress:
                continue
            
            term_start = term.get("startYear")
            term_end = term.get("endYear")
            
            # Convert to int
            try:
                term_start = int(term_start) if term_start else None
                term_end = int(term_end) if term_end else float("inf")
            except (ValueError, TypeError):
                continue
            
            if term_start is None:
                continue
            
            chamber = term.get("chamber", "").lower()
            term_state = term.get("state", member_state)
            term_district = term.get("district")
            
            # Include member if term overlaps session
            if term_start <= session_end and term_end >= session_start:
                member_info = {
                    "bio_id": bio_id,
                    "name": name,
                    "party": party_name,  # Add party here
                    "chamber": chamber,
                    "state": term_state,
                    "district": term_district,
                    "start_year": term_start
                }
                
                if chamber == "house of representatives":
                    district_str = str(term_district) if term_district is not None else "AL"
                    seat_key = f"{term_state}-{district_str}-{bio_id}"
                    
                    if seat_key not in house_seats or member_info['start_year'] > house_seats[seat_key]['start_year']:
                        house_seats[seat_key] = member_info
                        
                elif chamber == "senate":
                    seat_key = f"{term_state}-{bio_id}"
                    
                    if seat_key not in senate_seats or member_info['start_year'] > senate_seats[seat_key]['start_year']:
                        senate_seats[seat_key] = member_info
    
    print(f"\nHouse seats collected: {len(house_seats)}")
    print(f"Senate seats collected: {len(senate_seats)}")
    
    # Deduplicate by actual seats
    final_house_seats = {}
    for member_info in house_seats.values():
        district_str = str(member_info['district']) if member_info['district'] is not None else "AL"
        actual_seat_key = f"{member_info['state']}-{district_str}"
        
        if actual_seat_key not in final_house_seats:
            final_house_seats[actual_seat_key] = member_info
        else:
            if member_info['start_year'] > final_house_seats[actual_seat_key]['start_year']:
                final_house_seats[actual_seat_key] = member_info
    
    final_senate_seats = {}
    for member_info in senate_seats.values():
        state = member_info['state']
        state_seats = [k for k in final_senate_seats.keys() if k.startswith(f"{state}-")]
        
        if len(state_seats) == 0:
            final_senate_seats[f"{state}-1"] = member_info
        elif len(state_seats) == 1:
            final_senate_seats[f"{state}-2"] = member_info
        else:
            seat1_key = f"{state}-1"
            seat2_key = f"{state}-2"
            
            if member_info['start_year'] > final_senate_seats[seat1_key]['start_year']:
                if final_senate_seats[seat1_key]['start_year'] < final_senate_seats[seat2_key]['start_year']:
                    final_senate_seats[seat1_key] = member_info
                else:
                    final_senate_seats[seat2_key] = member_info
            elif member_info['start_year'] > final_senate_seats[seat2_key]['start_year']:
                final_senate_seats[seat2_key] = member_info
    
    print(f"Final house seats after dedup: {len(final_house_seats)}")
    print(f"Final senate seats after dedup: {len(final_senate_seats)}")
    
    house_members = [
        {k: v for k, v in m.items() if k != 'start_year'} 
        for m in final_house_seats.values()
    ]
    senate_members = [
        {k: v for k, v in m.items() if k != 'start_year'} 
        for m in final_senate_seats.values()
    ]
    all_members = house_members + senate_members
    
    return all_members, house_members, senate_members

# ---- Main ----
if __name__ == "__main__":
    # Change these as needed
    target_congress = 115
    session = 2
    
    print(f"\nProcessing Congress {target_congress}, Session {session}")
    print("=" * 60)
    
    session_start, session_end = get_session_range(target_congress, session)
    print(f"Session years: {session_start} - {session_end}")
    
    all_members = fetch_all_members(target_congress)
    all_active, house_active, senate_active = filter_active_members(
        all_members, session_start, session_end, target_congress
    )
    
    print("\n" + "=" * 60)
    print(f"Active members for session {session}:")
    print(f"  Total: {len(all_active)}")
    print(f"  House: {len(house_active)}")
    print(f"  Senate: {len(senate_active)}")
    print("=" * 60)
    
    # Create output directory if it doesn't exist
    output_dir = "assets/Congress"
    os.makedirs(output_dir, exist_ok=True)
    
    house_file = f"{output_dir}/house_members_{target_congress}_session{session}.json"
    senate_file = f"{output_dir}/senate_members_{target_congress}_session{session}.json"
    all_file = f"{output_dir}/all_members_{target_congress}_session{session}.json"
    
    with open(house_file, "w", encoding="utf-8") as f:
        json.dump(house_active, f, indent=4, ensure_ascii=False)
    print(f"\n✓ Saved House members to: {house_file}")
    
    with open(senate_file, "w", encoding="utf-8") as f:
        json.dump(senate_active, f, indent=4, ensure_ascii=False)
    print(f"✓ Saved Senate members to: {senate_file}")
    
    with open(all_file, "w", encoding="utf-8") as f:
        json.dump(all_active, f, indent=4, ensure_ascii=False)
    print(f"✓ Saved all members to: {all_file}")
    
    print("\n✓ Done!")