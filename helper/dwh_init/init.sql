drop table IF EXISTS "olist-dwh".public.fact_sales_analysis;
drop table IF EXISTS "olist-dwh".public.fact_customer_feedback;
drop table IF EXISTS "olist-dwh".public.fact_order_items;
drop table IF EXISTS "olist-dwh".public.fact_order;
drop table IF EXISTS "olist-dwh".public.dim_seller;
drop table IF EXISTS "olist-dwh".public.dim_product;
drop table IF EXISTS "olist-dwh".public.dim_customer;
drop table IF EXISTS "olist-dwh".public.dim_date;

-- Dimension Table: dim_customer
CREATE TABLE dim_customer
(
    customer_sk              UUID                     DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id              VARCHAR(32) NOT NULL,                               -- Unique customer identifier
    customer_unique_id       VARCHAR(100),                                       -- Unique ID assigned to customer
    customer_zip_code_prefix VARCHAR(10),                                        -- Zip code prefix of the customer
    customer_city            VARCHAR(100),                                       -- City where the customer resides
    customer_state           VARCHAR(2),                                         -- State where the customer resides
    created_at               TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Record creation date,
    effective_start_date     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Start date for the record
    effective_end_date       TIMESTAMP WITH TIME ZONE,                           -- End date for the record (null if current)
    is_active                BOOLEAN                  DEFAULT TRUE               -- Flag to indicate if the record is current
);

-- Dimension Table: dim_product
CREATE TABLE dim_product
(
    product_sk                 UUID                     DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id                 VARCHAR(32) NOT NULL,                               -- Unique product identifier
    product_category_name      VARCHAR(100),                                       -- Category name of the product
    product_name_length        INT,                                                -- Length of the product name
    product_description_length INT,                                                -- Length of the product description
    product_photos_qty         INT,                                                -- Number of photos for the product
    product_weight_g           DECIMAL(10, 2),                                     -- Product weight in grams
    product_length_cm          DECIMAL(10, 2),                                     -- Product length in cm
    product_height_cm          DECIMAL(10, 2),                                     -- Product height in cm
    product_width_cm           DECIMAL(10, 2),                                     -- Product width in cm
    created_at                 TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Record creation date
    effective_start_date       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Start date for the record
    effective_end_date         TIMESTAMP WITH TIME ZONE,                           -- End date for the record (null if current)
    is_active                  BOOLEAN                  DEFAULT TRUE               -- Flag to indicate if the record is current
);

-- Dimension Table: dim_seller
CREATE TABLE dim_seller
(
    seller_sk              UUID                     DEFAULT gen_random_uuid() PRIMARY KEY,
    seller_id              VARCHAR(32) NOT NULL,                               -- Unique seller identifier
    seller_zip_code_prefix INTEGER,                                            -- Zip code prefix of the seller
    seller_city            VARCHAR(100),                                       -- City where the seller is located
    seller_state           VARCHAR(2),                                         -- State where the seller is located
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Record creation date
    effective_start_date   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Start date for the record
    effective_end_date     TIMESTAMP WITH TIME ZONE,                           -- End date for the record (null if current)
    is_active              BOOLEAN                  DEFAULT TRUE               -- Flag to indicate if the record is current
);


-- Fact Table: fact_order_processing
CREATE TABLE fact_order
(
    order_sk                      UUID DEFAULT gen_random_uuid() PRIMARY KEY, -- Unique identifier for each fact order
    order_id                      VARCHAR(32) NOT NULL,                       -- Reference to the order ID
    customer_sk                   UUID        NOT NULL,                       -- Reference to the customer ID
    order_status                  VARCHAR(20),                                -- Status of the order
    order_approved_at             TIMESTAMP WITH TIME ZONE,
    order_purchase_timestamp      TIMESTAMP WITH TIME ZONE,                   -- Purchase date of the order
    order_delivered_carrier_date  TIMESTAMP WITH TIME ZONE,
    order_delivered_customer_date TIMESTAMP WITH TIME ZONE,                   -- Delivery date to the customer
    order_estimated_delivery_date TIMESTAMP WITH TIME ZONE,                   -- Estimated delivery date
    FOREIGN KEY (customer_sk) REFERENCES dim_customer (customer_sk)           -- Foreign key reference to dim_customer

);

-- Fact Table: fact_order_processing_items
create table fact_order_items
(
    order_item_sk       UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_sk            UUID    not null,
    order_item_id       integer not null,
    product_sk          UUID,
    seller_sk           UUID,
    shipping_limit_date TIMESTAMP WITH TIME ZONE,
    price               numeric,
    freight_value       numeric,
    FOREIGN KEY (order_sk) REFERENCES fact_order (order_sk),
    FOREIGN KEY (product_sk) REFERENCES dim_product (product_sk),
    FOREIGN KEY (seller_sk) REFERENCES dim_seller (seller_sk)
);


-- Fact Table: fact_customer_feedback
CREATE TABLE fact_customer_feedback
(
    review_sk              UUID DEFAULT gen_random_uuid() PRIMARY KEY, -- Unique identifier for each feedback
    review_id              VARCHAR(32) NOT NULL,                       -- Reference to the review ID
    order_sk               UUID        NOT NULL,                       -- Reference to the order ID
    review_score           INTEGER,                                    -- Score given by the customer
    review_comment_title   TEXT,                                       -- Title of the review
    review_comment_message TEXT,                                       -- Detailed feedback from the customer
    review_creation_date   DATE                                        -- Creation date of the review
);

-- Fact Table: fact_sales_analysis
CREATE TABLE fact_sales_analysis
(
    sales_sk       UUID DEFAULT gen_random_uuid() PRIMARY KEY,   -- Unique identifier for each sales analysis record
    product_sk     UUID NOT NULL,                                -- Reference to the product ID
    order_date     DATE NOT NULL,                                -- Date of the order
    total_sales    NUMERIC,                                      -- Total sales for the product on the given date
    total_quantity INTEGER,                                      -- Total quantity sold
    FOREIGN KEY (product_sk) REFERENCES dim_product (product_sk) -- Foreign key reference to dim_product
);
