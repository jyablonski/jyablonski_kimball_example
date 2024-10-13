USE DATABASE production;  -- Use your Snowflake database
USE SCHEMA source;  -- Set the schema to 'source'

-- Payment type table
CREATE TABLE payment_type (
    id INTEGER AUTOINCREMENT, 
    payment_type STRING,
    financial_account_id INTEGER NOT NULL,
    payment_type_description STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer table
CREATE TABLE customer (
    id INTEGER AUTOINCREMENT, 
    customer_name STRING,
    customer_email STRING,
    address STRING,
    address_2 STRING,
    city STRING,
    zip_code INTEGER,
    state STRING,
    country STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer audit table
CREATE TABLE customer_audit (
    id INTEGER AUTOINCREMENT, 
    audit_type INTEGER,
    customer_id INTEGER,
    customer_name STRING,
    customer_email STRING,
    address STRING,
    address_2 STRING,
    city STRING,
    zip_code INTEGER,
    state STRING,
    country STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Store table
CREATE TABLE store (
    id INTEGER AUTOINCREMENT, 
    store_name STRING,
    street STRING,
    city STRING,
    state STRING,
    zip_code INTEGER,
    country STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order table
CREATE TABLE "order" (
    id INTEGER AUTOINCREMENT, 
    customer_id INTEGER,
    store_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product category table
CREATE TABLE product_category (
    id INTEGER AUTOINCREMENT, 
    product_category_name STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product table
CREATE TABLE product (
    id INTEGER AUTOINCREMENT, 
    product_name STRING,
    product_category_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product price table
CREATE TABLE product_price (
    id INTEGER AUTOINCREMENT, 
    product_id INTEGER,
    price DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order detail table
CREATE TABLE order_detail (
    id INTEGER AUTOINCREMENT, 
    order_id INTEGER,
    product_id INTEGER,
    product_price_id INTEGER,
    quantity INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Invoice table
CREATE TABLE invoice (
    id INTEGER AUTOINCREMENT, 
    order_id INTEGER,
    total_amount DECIMAL(10, 2) NOT NULL,
    currency STRING DEFAULT 'USD',
    is_voided BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Financial account table
CREATE TABLE financial_account (
    id INTEGER AUTOINCREMENT, 
    financial_account_name STRING NOT NULL,
    financial_account_type STRING,
    financial_account_description STRING,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment table
CREATE TABLE payment (
    id INTEGER AUTOINCREMENT, 
    amount DECIMAL(10, 2),
    payment_type_id INTEGER,
    payment_type_detail STRING,
    invoice_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Integration table
CREATE TABLE integration (
    id INTEGER AUTOINCREMENT, 
    customer_id INTEGER,
    integration_type STRING,
    is_active INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order JSON table
CREATE TABLE source.order_json (
    id INTEGER AUTOINCREMENT, 
    external_data VARIANT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO payment_type (payment_type, financial_account_id, payment_type_description)
VALUES
    ('Cash', 1, 'Cash Transaction'),
    ('Credit Card', 2, 'Credit Card Transaction'),
    ('Gift Card', 1, 'Gift Card Transaction'),
    ('Debit Card', 3, 'Debit Card Transaction');

INSERT INTO store (id, store_name, street, city, state, zip_code, country)
VALUES
    (1, 'Johnny Allstar Allparts', '123 Milky Way', 'Los Angeles', 'CA', 92679, 'USA'),
    (2, 'Barneys Autoparts', '342 Rivers Walk', 'Las Vegas', 'NV', 43342, 'USA'),
    (10, 'Minneys Emporium', '4443 Hoozier Boulevard', 'Chicago', 'IL', 60601, 'USA');

INSERT INTO financial_account (financial_account_name, financial_account_type, financial_account_description)
VALUES 
    ('Cash', 'Asset', 'Account for Cash'),
    ('Accounts Receivable', 'Asset', 'Account for AR'),
    ('Bank Account', 'Asset', 'Account for Bank Balance'),
    ('Sales Revenue', 'Revenue', 'Account for all Store Revenue'),
    ('Cost of Goods Sold', 'Expense', 'Account for COGS'),
    ('Operating Expenses', 'Expense', 'Account for General Expenses');

INSERT INTO customer (customer_name, customer_email, address, address_2, city, zip_code, state, country, created_at, modified_at)
VALUES
    ('Johnny Allstar', 'johnny@allstar.com', '15 Sagefoot', null, 'Los Angeles', 44433, 'CA', 'USA', '2024-01-01 00:30:00', current_timestamp),
    ('Aubrey Plaza', 'fake@nobody.com', '456 Elm St', null, 'Metropolis', 54321, 'NY', 'USA', current_timestamp, current_timestamp),
    ('John Wick', 'customer3@example.com', '789 Oak St', 'Apt 1615', 'Los Angeles', 67890, 'CA', 'USA', current_timestamp, current_timestamp);

INSERT INTO customer_audit (id, audit_type, customer_id, customer_name, customer_email, address, address_2, city, zip_code, state, country, created_at, modified_at)
VALUES
    (1, 0, 1, 'Johnny Allstar', 'customer1@example.com', '123 Main St', 'Apt 4B', 'Springfield', 12345, 'IL', 'USA', '2024-01-01 00:30:00', '2024-01-01 00:30:00'),
    (2, 1, 1, 'Johnny Allstar', 'johnny@allstar.com', '13 Peak Trail', null, 'Las Vegas', 11112, 'NV', 'USA', '2024-01-01 00:30:00', '2024-03-01 12:00:00'),
    (3, 1, 1, 'Johnny Allstar', 'johnny@allstar.com', '6 Moccasin', null, 'Trabuco Canyon', 92679, 'CA', 'USA', '2024-01-01 00:30:00', '2024-06-01 09:00:00'),
    (4, 0, 1, 'Bobby Newport', 'newportb@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-01-01 04:30:00'),
    (5, 1, 1, 'Bobby Newport', 'bobby999@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-05-01 15:30:00'),
    (6, 2, 1, 'Bobby Newport', 'bobby999@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-06-15 00:30:00'),
    (7, 0, 2, 'Aubrey Plaza', 'fake@nobody.com', '456 Elm St', null, 'Metropolis', 54321, 'NY', 'USA', current_timestamp, current_timestamp),
    (8, 0, 3, 'John Wick', 'customer3@example.com', '789 Oak St', 'Apt 1615', 'Los Angeles', 67890, 'CA', 'USA', current_timestamp, current_timestamp),
    (9, 1, 1, 'Johnny Allstar', 'johnny@allstar.com', '15 Sagefoot', null, 'Los Angeles', 44433, 'CA', 'USA', '2024-01-01 00:30:00', current_timestamp);

INSERT INTO product_category (id, product_category_name)
VALUES
    (1, 'Food & Beverage'),
    (2, 'Electronics'),
    (3, 'General Goods');

INSERT INTO product (product_name, product_category_id)
VALUES
    ('Apples', 1),
    ('Gameboy', 2),
    ('Paper', 3),
    ('Blueberries', 1),
    ('Raspberries', 1),
    ('Nintendo DS', 2),
    ('Staples', 3),
    ('Office Chair', 3),
    ('HDMI Cable', 2);

INSERT INTO product_price (id, product_id, price, is_active, valid_from, valid_to)
VALUES
    (1, 1, 12.99, false, '2023-01-01 00:00:00', current_timestamp),
    (2, 1, 15.99, true, current_timestamp, '2039-12-31 23:59:59'),
    (3, 2, 45.99, true, current_timestamp, '2039-12-31 23:59:59'),
    (4, 3, 5.99, true, current_timestamp, '2039-12-31 23:59:59'),
    (5, 4, 3.99, true, current_timestamp, '2039-12-31 23:59:59'); 

INSERT INTO integration (customer_id, integration_type, is_active)
VALUES
    (1, 'Mailchimp', 1),
    (2, 'Salesforce', 1),
    (3, 'Hubspot', 0);

INSERT INTO integration (customer_id, integration_type, is_active, created_at)
VALUES
    (1, 'Mailchimp', 0, current_timestamp + interval '7 days'),
    (1, 'Salesforce', 1, current_timestamp + interval '7 days'),
    (2, 'Salesforce', 0, current_timestamp + interval '7 days'),
    (3, 'Hubspot', 1, current_timestamp + interval '7 days'),
    (1, 'Mailchimp', 1, current_timestamp + interval '14 days'),
    (2, 'Salesforce', 1, current_timestamp + interval '14 days'),
    (3, 'Hubspot', 0, current_timestamp + interval '14 days'),
    (1, 'Salesforce', 0, current_timestamp + interval '21 days');

INSERT INTO source."order" (id, customer_id, store_id, created_at, modified_at)
VALUES 
    (1, 1, 1, current_timestamp - interval '38 day', current_timestamp - interval '38 day'),
    (2, 2, 1, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (3, 2, 2, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (4, 3, 10, current_timestamp, current_timestamp);


INSERT INTO order_detail (id, order_id, product_id, product_price_id, quantity, created_at, modified_at)
VALUES
    (1, 1, 1, 1, 1, current_timestamp - interval '38 day', current_timestamp - interval '38 day'),
    (2, 2, 1, 2, 1, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (3, 2, 2, 3, 1, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (4, 3, 4, 5, 1, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (5, 4, 3, 4, 1, current_timestamp, current_timestamp);

INSERT INTO invoice (order_id, total_amount, created_at, modified_at)
VALUES 
    (1, 15.99, current_timestamp - interval '38 day', current_timestamp - interval '38 day'),
    (2, 61.98, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (3, 21.98, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (4, 3.99, current_timestamp, current_timestamp);

INSERT INTO payment (amount, payment_type_id, payment_type_detail, invoice_id, created_at, modified_at)
VALUES 
    (15.99, 1, NULL, 1, current_timestamp - interval '38 day', current_timestamp - interval '38 day'),
    (61.98, 2, '4436', 2, current_timestamp - interval '14 day', current_timestamp - interval '14 day'),
    (10.00, 3, 'G42423241', 3, current_timestamp - interval '14 day', current_timestamp - interval '14 day');

INSERT INTO source.order_json (external_data)
SELECT PARSE_JSON('{"id": 1000, "source": {"address": "123 Wells Way", "store": "Walgreens", "state": "IL", "zip_code": 60601, "transaction_timestamp": "2023-09-17 20:00:00.000000"}, "sale_id": 4}');