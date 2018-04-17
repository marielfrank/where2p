# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# User 
user = User.create(email: "ghoti@testing.com", password: "test123", name: "ghoti", admin: true)

# Some Neighborhoods
ev = Neighborhood.create(name: "East Village")
fd = Neighborhood.create(name: "Financial District")
ct = Neighborhood.create(name: "Chinatown")
mt = Neighborhood.create(name: "Midtown")
wv = Neighborhood.create(name: "West Village")
uws = Neighborhood.create(name: "Upper West Side")
ues = Neighborhood.create(name: "Upper East Side")
les = Neighborhood.create(name: "Lower East Side")
ps_b = Neighborhood.create(name: "Park Slope - Brooklyn")
d_b = Neighborhood.create(name: "DUMBO - Brooklyn")
ph_b = Neighborhood.create(name: "Prospect Heights - Brooklyn")

# Restrooms
ph_b.restrooms.build(address: "200 Eastern Pkwy, Brooklyn, NY 11238", name: "Brooklyn Museum")
ev.restrooms.build(address: "85 E 4th St, New York, NY 10003", name: "KGB Bar")
fd.restrooms.build(address: "130 Fulton St, New York, NY 10038", name: "Starbucks - Fulton St")
ct.restrooms.build(address: "106 Mott St, New York, NY 10013", name: "Sweet Moment")
mt.restrooms.build(address: "58 W 42nd St, New York, NY 10036", name: "Bryant Park Public Restroom")
fd.restrooms.build(address: "42 Broadway, New York, NY 10004", name: "Gregory's Coffee - 42 Broadway")

ph_b.save
ev.save
fd.save
mt.save
ct.save

# Tags
Tag.create(description: "Unisex")
Tag.create(description: "Very clean")
Tag.create(description: "Usually empty")
Tag.create(description: "Women's only")
Tag.create(description: "Has a plunger")
Tag.create(description: "BYOTP")
Tag.create(description: "Wheelchair accessible")
Tag.create(description: "Upstairs")
Tag.create(description: "'Customers Only' sign")