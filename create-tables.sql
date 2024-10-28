-- Create your database tables here. Alternatively you may use an ORM
-- or whatever approach you prefer to initialize your database.
-- CREATE TABLE example_table (id SERIAL PRIMARY KEY, some_int INT, some_text TEXT);
-- INSERT INTO example_table (some_int, some_text) VALUES (123, 'hello');



CREATE TYPE unit AS ENUM('pt', 'px');


CREATE TABLE padding_dimensions (
    id SERIAL PRIMARY KEY,
    padding_top INT,
    padding_top_unit unit,
    padding_left INT,
    padding_left_unit unit,
    padding_right INT,
    padding_right_unit unit,
    padding_bottom INT,
    padding_bottom_unit unit
);

CREATE TABLE margin_dimensions (
    id SERIAL PRIMARY KEY,
    margin_top_value INT,
    margin_top_unit unit,
    margin_left INT,
    padding_left_unit unit,
    margin_right INT,
    padding_right_unit unit,
    margin_bottom INT,
    padding_bottom_unit unit
);


CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    margin_dimensions_id INT,
    padding_dimensions_id INT,
    CONSTRAINT fk_margin_dimensions_id FOREIGN KEY (margin_dimensions_id) REFERENCES margin_dimensions(id) ON DELETE CASCADE,
    CONSTRAINT fk_padding_dimensions_id FOREIGN KEY (padding_dimensions_id) REFERENCES padding_dimensions(id) ON DELETE CASCADE
);