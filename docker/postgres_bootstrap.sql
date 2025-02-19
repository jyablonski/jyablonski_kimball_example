ALTER SYSTEM SET wal_level = logical;
ALTER ROLE postgres WITH REPLICATION;

BEGIN;

CREATE SCHEMA source;
CREATE SCHEMA dbt_stg;
CREATE SCHEMA dbt_prod;

create user test_user with password 'password';
grant all privileges on database postgres to test_user;

-- **** AUDIT DATA HEADS UP ****
-- `audit_type` key
-- 0 = insert
-- 1 = update
-- 2 = delete

-- for audit tables - on updates and deletes to existing records, keep thje `created_at`
--  timestamp the same, but update the `modified_at` timestamp to the current timestamp

-- **** AUDIT DATA HEADS UP ****

-- default directory for every statement in this bootstrap
SET search_path TO source;

CREATE TYPE payment_enum AS ENUM ('Cash', 'Credit Card', 'Debit Card', 'Gift Card');
CREATE TABLE payment_type (
    id serial PRIMARY KEY,
    payment_type payment_enum,
    financial_account_id integer not null,
    payment_type_description varchar(100),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

-- Create the sales data tables
CREATE TABLE customer (
    id serial PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    address varchar(100),
    address_2 varchar(100),
    city varchar(50),
    zip_code integer,
    state varchar(3),
    country varchar(50),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE customer_audit (
    id serial PRIMARY KEY,
    audit_type integer,
    customer_id integer,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    address varchar(100),
    address_2 varchar(100),
    city varchar(50),
    zip_code integer,
    state varchar(3),
    country varchar(50),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE emails (
    id serial PRIMARY KEY,
    email_name varchar(100),
    messages json,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE store (
    id serial PRIMARY KEY,
    store_name varchar(100),
    street varchar(100),
    city varchar(100),
    state varchar(2),
    zip_code integer,
    country varchar(50),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE source.order (
    id serial primary key,
    customer_id integer,
    store_id integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_store_id FOREIGN KEY (store_id) REFERENCES store(id)
);


CREATE TABLE product_category (
    id serial PRIMARY KEY,
    product_category_name varchar(100),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE product (
    id serial PRIMARY KEY,
    product_name VARCHAR(100),
    product_category_id integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_product_category_id FOREIGN KEY (product_category_id) REFERENCES product_category(id)

);

-- new records make it really easy to make scd2 tables
CREATE TABLE product_price (
    id serial PRIMARY KEY,
    product_id integer,
    price DECIMAL(10, 2),
    is_active boolean default TRUE,
    valid_from timestamp default current_timestamp,
    valid_to timestamp,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES product(id)
);

-- one-> many relationship between order and order_details 
CREATE TABLE order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_price_id integer NOT NULL,
    quantity INT NOT NULL,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES source.order(id),
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT fk_product_price_id FOREIGN KEY (product_price_id) REFERENCES product_price(id)
);

CREATE TABLE invoice (
    id serial PRIMARY KEY,
    order_id integer,
    total_amount DECIMAL(10, 2) NOT NULL,
    currency varchar(3) default 'USD',
    is_voided boolean default FALSE,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES source.order(id)

);

CREATE TYPE financial_account_enum AS ENUM ('Asset', 'Equity', 'Expense', 'Liability', 'Revenue');
CREATE TABLE financial_account (
    id serial PRIMARY KEY,
    financial_account_name varchar(100) NOT NULL,
    financial_account_type financial_account_enum,
    financial_account_description text,
    is_active boolean DEFAULT true,
    created_at timestamp DEFAULT current_timestamp,
    modified_at timestamp DEFAULT current_timestamp
);

CREATE TABLE payment (
    id serial PRIMARY KEY,
    amount decimal(10, 2),
    payment_type_id integer,
    payment_type_detail varchar(100),
    invoice_id integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_invoice_id FOREIGN KEY (invoice_id) REFERENCES invoice(id),
    CONSTRAINT fk_payment_type_id FOREIGN KEY (payment_type_id) REFERENCES payment_type(id)
);


-- this basically acts as an audit table - will have multiple rows for each change per customer id / integration
CREATE TYPE integration_enum AS ENUM ('Mailchimp', 'Salesforce', 'Hubspot');
CREATE TABLE integration (
    id serial PRIMARY KEY,
    customer_id integer,
    integration_type integration_enum,
    is_active integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE source.order_json (
    id serial PRIMARY KEY,
    external_data json not null,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE source.sales_data (
    id serial primary key,
    name varchar(100),
    address varchar(100),
    username varchar(100),
    email varchar(100),
    hire_date date,
    status varchar(100),
    color varchar(100),
    salary decimal(10, 2),
    store_id integer,
    created_at timestamp default current_timestamp
);

INSERT INTO emails (email_name, messages)
VALUES 
    (
        'Newsletter Campaign', 
        '{
            "550e8400-e29b-41d4-a716-446655440000": { "subject": "Welcome to our service!" },
            "550e8400-e29b-41d4-a716-446655440001": {}
        }'
    ),
    (
        'Follow-up Emails', 
        '{
            "660f8501-f39c-51e5-b827-557766550002": { "subject": "We miss you!" },
            "660f8501-f39c-51e5-b827-557766550003": { "subject": "Special Offer Inside" }
        }'
    ),
    (
        'Transactional Emails', 
        '{
            "770a9602-g49d-62f6-c928-668877660004": {},
            "770a9602-g49d-62f6-c928-668877660005": { "subject": "Your receipt is ready" }
        }'
    ),
    (
        'Promotional Emails', 
        '{
            "880b0703-h50e-73g7-d039-779988770006": { "subject": "Limited-Time Discount!" },
            "880b0703-h50e-73g7-d039-779988770007": {}
        }'
    ),
    (
        'Marketing Emails', 
        '{
            "880b0703-h50e-73g7-d039-779988770011": {},
            "880b0703-h50e-73g7-d039-779988770012": {}
        }'
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
    (4, 0, 4, 'Bobby Newport', 'newportb@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-01-01 04:30:00'),
    (5, 1, 4, 'Bobby Newport', 'bobby999@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-05-01 15:30:00'),
    (6, 2, 4, 'Bobby Newport', 'bobby999@gmail.com', '123 Yellowbrook Lane', null, 'Ridgewood', 75620, 'CA', 'USA', '2024-01-01 00:30:00', '2024-06-15 00:30:00'),
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

INSERT INTO source.order (id, customer_id, store_id, created_at, modified_at)
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
VALUES
    ('{"id": 1000, "source": {"address": "123 Wells Way", "store": "Walgreens", "state": "IL", "zip_code": 60601, "transaction_timestamp": "2023-09-17 20:00:00.000000"}, "sale_id": 4}');

COMMIT;