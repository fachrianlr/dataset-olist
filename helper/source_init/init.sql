-- 1. Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- Load data from CSV for Customers Table
COPY customers(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
FROM '/docker-entrypoint-initdb.d/csv/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 2. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) REFERENCES customers(customer_id),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- Load data from CSV for Orders Table
COPY orders(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at,
            order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
FROM '/docker-entrypoint-initdb.d/csv/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 3. Sellers Table
CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

-- Load data from CSV for Sellers Table
COPY sellers(seller_id, seller_zip_code_prefix, seller_city, seller_state)
FROM '/docker-entrypoint-initdb.d/csv/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 4. Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g DECIMAL,
    product_length_cm DECIMAL,
    product_height_cm DECIMAL,
    product_width_cm DECIMAL
);

-- Load data from CSV for Products Table
COPY products(product_id, product_category_name, product_name_lenght, product_description_lenght,
              product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM '/docker-entrypoint-initdb.d/csv/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 5. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(32) REFERENCES orders(order_id),
    order_item_id INTEGER,
    product_id VARCHAR(32) REFERENCES products(product_id),
    seller_id VARCHAR(32) REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price DECIMAL,
    freight_value DECIMAL,
    PRIMARY KEY (order_id, order_item_id)
);

-- Load data from CSV for Order Items Table
COPY order_items(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
FROM '/docker-entrypoint-initdb.d/csv/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 6. Order Payments Table
CREATE TABLE IF NOT EXISTS order_payments (
    order_id VARCHAR(32) REFERENCES orders(order_id),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL,
    PRIMARY KEY (order_id, payment_sequential)
);

-- Load data from CSV for Order Payments Table
COPY order_payments(order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM '/docker-entrypoint-initdb.d/csv/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 7. Order Reviews Table
CREATE TABLE IF NOT EXISTS order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32) REFERENCES orders(order_id),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);

-- Load data from CSV for Order Reviews Table
COPY order_reviews(review_id, order_id, review_score, review_comment_title, review_comment_message,
                   review_creation_date, review_answer_timestamp)
FROM '/docker-entrypoint-initdb.d/csv/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 8. Geolocation Table
CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DECIMAL,
    geolocation_lng DECIMAL,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

-- Load data from CSV for Geolocation Table
COPY geolocation(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
FROM '/docker-entrypoint-initdb.d/csv/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

-- 9. Product Category Translation Table
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Load data from CSV for Product Category Translation Table
COPY product_category_name_translation(product_category_name, product_category_name_english)
FROM '/docker-entrypoint-initdb.d/csv/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;
