system "dropdb shopping_list"
system "createdb shopping_list"
system "psql shopping_list < data/schema.sql"
# system "psql shopping_list < data/seed_data.sql"