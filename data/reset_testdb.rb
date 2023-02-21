system "dropdb shopping_list_test"
system "createdb shopping_list_test"
system "psql shopping_list_test < data/schema.sql"
system "psql shopping_list_test < data/test_seed_data.sql"