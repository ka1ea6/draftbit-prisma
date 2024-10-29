-- Create your database tables here. Alternatively you may use an ORM
-- or whatever approach you prefer to initialize your database.
-- CREATE TABLE example_table (id SERIAL PRIMARY KEY, some_int INT, some_text TEXT);
-- INSERT INTO example_table (some_int, some_text) VALUES (123, 'hello');



CREATE TYPE unit AS ENUM('pt', 'px');



CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE dimensions (
    id SERIAL PRIMARY KEY,
    padding_top INT,
    padding_top_unit unit,
    padding_left INT,
    padding_left_unit unit,
    padding_right INT,
    padding_right_unit unit,
    padding_bottom INT,
    padding_bottom_unit unit,
    margin_top INT,
    margin_top_unit unit,
    margin_left INT,
    margin_left_unit unit,
    margin_right INT,
    margin_right_unit unit,
    margin_bottom INT,
    margin_bottom_unit unit,
    item_id INT,
    CONSTRAINT fk_items_id FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

-- CREATE TABLE margin_dimensions (
--     id SERIAL PRIMARY KEY,
-- );





