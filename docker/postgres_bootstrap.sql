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
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE TABLE user_sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    session_start TIMESTAMP NOT NULL,
    session_end TIMESTAMP NOT NULL,
    device TEXT NOT NULL,
    country TEXT NOT NULL
);

-- Insert 100 random rows
INSERT INTO user_sessions (user_id, session_start, session_end, device, country)
SELECT
    (random() * 1000)::INT + 1 AS user_id, -- Random user IDs between 1 and 1000
    ts AS session_start,
    ts + (INTERVAL '1 minute' * (10 + (random() * 350))) AS session_end, -- 10–360 minutes long
    (ARRAY['desktop', 'mobile', 'tablet'])[floor(random() * 3 + 1)] AS device,
    (ARRAY['US', 'CA', 'GB', 'AU', 'DE'])[floor(random() * 5 + 1)] AS country
FROM (
    SELECT
        TIMESTAMP '2020-01-01'
        + (random() * EXTRACT(EPOCH FROM TIMESTAMP '2025-08-15' - TIMESTAMP '2020-01-01')) * INTERVAL '1 second'
        AS ts
    FROM generate_series(1, 100)
);

COMMIT;


CREATE TABLE user_actions (
    id UUID primary key default uuid_generate_v4(),
    user_id VARCHAR,
    event VARCHAR, -- click, page_view or something etc
    email VARCHAR,
    created_at timestamp default current_timestamp
);

-- NOTE: this is completely separate from the actual `store` table and is only used to practice the SCD2 macro
CREATE TABLE store_audit (
    id SERIAL PRIMARY KEY,
    store_id INTEGER NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    region VARCHAR(50),
    square_footage INTEGER,
    store_type VARCHAR(50), -- 'flagship', 'standard', 'outlet'
    monthly_rent DECIMAL(10, 2),
    opened_date DATE,
    audit_type INTEGER, -- 1 = insert, 2 = update, 3 = delete
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_geolocation_audit (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    zip_code VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    device_type VARCHAR(50), -- 'mobile', 'desktop', 'tablet'
    device_os VARCHAR(50),
    browser VARCHAR(50),
    ip_address VARCHAR(45),
    is_vpn BOOLEAN DEFAULT FALSE,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



-- Sample data for user_actions table
-- Demonstrates scenarios where:
-- 1. Multiple user_ids can share the same email (shared/family emails)
-- 2. One user_id can have multiple emails (email changes)

INSERT INTO user_actions (user_id, event, email, created_at) VALUES
-- Person 1: John - changed his email from gmail to work email
('user_001', 'signup', 'john.doe@gmail.com', '2023-01-15 10:30:00'),
('user_001', 'login', 'john.doe@gmail.com', '2023-02-01 14:20:00'),
('user_001', 'email_change', 'john.doe@techcorp.com', '2023-03-15 09:15:00'),
('user_001', 'purchase', 'john.doe@techcorp.com', '2023-04-22 16:45:00'),

-- Person 2: Sarah - uses family email initially, then gets her own
('user_002', 'signup', 'family.smith@yahoo.com', '2023-01-20 11:00:00'),
('user_002', 'email_change', 'sarah.smith@outlook.com', '2023-05-10 13:30:00'),

-- Person 3: Mike - different user_id but uses John's old email (maybe bought account or email was reassigned)
('user_003', 'signup', 'john.doe@gmail.com', '2023-06-01 08:45:00'),
('user_003', 'login', 'john.doe@gmail.com', '2023-06-03 08:45:00'),
('user_003', 'delete', 'john.doe@gmail.com', '2023-06-05 08:45:00'),

-- Person 4: Lisa - uses the same family email that Sarah initially used
('user_004', 'signup', 'family.smith@yahoo.com', '2023-02-28 19:20:00'),
('user_004', 'login', 'family.smith@yahoo.com', '2023-03-05 12:10:00'),

-- Person 5: Alex - consistent email usage
('user_005', 'signup', 'alex.johnson@protonmail.com', '2023-04-10 15:25:00'),


-- person 3 again, but this time on a new user_id
('user_006', 'signup', 'john.doe@gmail.com', '2025-08-25 08:45:00');

INSERT INTO user_actions (user_id, event, email, created_at) VALUES

-- Edge Case 1: Chain of 3+ deletions/signups (A→B→C)
('user_007', 'signup', 'recycled@email.com', '2023-07-01 10:00:00'),
('user_007', 'delete', 'recycled@email.com', '2023-08-01 10:00:00'),
('user_008', 'signup', 'recycled@email.com', '2023-08-15 10:00:00'),
('user_008', 'delete', 'recycled@email.com', '2023-09-01 10:00:00'),
('user_009', 'signup', 'recycled@email.com', '2023-09-15 10:00:00'),

-- Edge Case 2: User deletes, someone else uses email briefly, original user comes back
('user_010', 'signup', 'temp@email.com', '2023-10-01 10:00:00'),
('user_010', 'delete', 'temp@email.com', '2023-11-01 10:00:00'),
('user_011', 'signup', 'temp@email.com', '2023-11-15 10:00:00'),  -- Different person
('user_011', 'delete', 'temp@email.com', '2023-12-01 10:00:00'),
('user_012', 'signup', 'temp@email.com', '2024-01-01 10:00:00'),  -- Original person back?

-- Edge Case 3: Multiple emails, user deletes one account but keeps another active
('user_013', 'signup', 'primary@email.com', '2023-05-01 10:00:00'),
('user_014', 'signup', 'secondary@email.com', '2023-05-02 10:00:00'),  -- Same person, different email
('user_014', 'delete', 'secondary@email.com', '2023-06-01 10:00:00'),  -- Deletes secondary
('user_015', 'signup', 'secondary@email.com', '2023-06-15 10:00:00'),  -- New person uses deleted email

-- Edge Case 4: User changes email, THEN deletes, new user uses the changed-to email
('user_016', 'signup', 'original@email.com', '2023-03-01 10:00:00'),
('user_016', 'email_change', 'changed@email.com', '2023-04-01 10:00:00'),
('user_016', 'delete', 'changed@email.com', '2023-05-01 10:00:00'),
('user_017', 'signup', 'changed@email.com', '2023-05-15 10:00:00'),  -- Uses the changed-to email

-- Edge Case 5: Same user deletes and re-signs up multiple times (serial deleter)
('user_018', 'signup', 'serial@email.com', '2023-01-01 10:00:00'),
('user_018', 'delete', 'serial@email.com', '2023-02-01 10:00:00'),
('user_019', 'signup', 'serial@email.com', '2023-02-15 10:00:00'),  -- Same person back
('user_019', 'delete', 'serial@email.com', '2023-03-01 10:00:00'),
('user_020', 'signup', 'serial@email.com', '2023-03-15 10:00:00'),  -- Same person again

-- Edge Case 6: Two different people alternating with same email
('user_021', 'signup', 'shared@company.com', '2023-01-01 09:00:00'),  -- Person A
('user_021', 'delete', 'shared@company.com', '2023-03-01 09:00:00'),
('user_022', 'signup', 'shared@company.com', '2023-03-15 09:00:00'),  -- Person B
('user_022', 'delete', 'shared@company.com', '2023-06-01 09:00:00'),
('user_023', 'signup', 'shared@company.com', '2023-06-15 09:00:00'),  -- Person A again
('user_023', 'delete', 'shared@company.com', '2023-09-01 09:00:00'),
('user_024', 'signup', 'shared@company.com', '2023-09-15 09:00:00'),  -- Person B again

-- Edge Case 7: Gap in activity - did they come back or is it someone else?
('user_025', 'signup', 'gap@email.com', '2020-01-01 10:00:00'),
('user_025', 'delete', 'gap@email.com', '2020-02-01 10:00:00'),
-- Long gap (3+ years)
('user_026', 'signup', 'gap@email.com', '2024-01-01 10:00:00'),  -- Same person or coincidence?

-- Edge Case 8: User changes email, deletes, then comes back with the changed-to email
('user_027', 'signup', 'start@email.com', '2023-01-01 10:00:00'),
('user_027', 'email_change', 'final@email.com', '2023-02-01 10:00:00'),
('user_027', 'delete', 'final@email.com', '2023-03-01 10:00:00'),
('user_028', 'signup', 'final@email.com', '2023-03-15 10:00:00');  -- Same person back with their changed-to email

-- incremental test if needed
/* 
INSERT INTO source.user_actions (user_id, event, email, created_at) VALUES

-- Edge Case 1: Chain of 3+ deletions/signups (A→B→C)
('user_050', 'signup', 'babygirl@email.com', '2023-08-25 10:00:00'),
('user_050', 'delete', 'babygirl@email.com', '2023-08-28 10:00:00'),
('user_051', 'signup', 'babygirl@email.com', '2023-08-29 10:00:00');
*/

-- Store 101: Standard lifecycle with updates
INSERT INTO store_audit (store_id, store_name, manager_name, region, square_footage, store_type, monthly_rent, opened_date, audit_type, modified_at)
VALUES 
    (101, 'Downtown Seattle', 'Alice Johnson', 'Pacific Northwest', 5000, 'standard', 12000.00, '2023-01-15', 1, '2023-01-15 08:00:00'),
    (101, 'Downtown Seattle', 'Bob Wilson', 'Pacific Northwest', 5000, 'standard', 12000.00, '2023-01-15', 1, '2023-06-01 10:30:00'), -- manager change
    (101, 'Downtown Seattle Flagship', 'Bob Wilson', 'Pacific Northwest', 7500, 'flagship', 18000.00, '2023-01-15', 1, '2024-03-15 14:20:00'); -- remodel + rent increase

-- Store 102: Closed store
INSERT INTO store_audit (store_id, store_name, manager_name, region, square_footage, store_type, monthly_rent, opened_date, audit_type, modified_at)
VALUES 
    (102, 'Portland Mall', 'Carol Davis', 'Pacific Northwest', 4200, 'standard', 9500.00, '2022-08-01', 1, '2022-08-01 09:00:00'),
    (102, 'Portland Mall', 'Carol Davis', 'Pacific Northwest', 4200, 'outlet', 7000.00, '2022-08-01', 1, '2023-11-10 11:00:00'), -- converted to outlet
    (102, 'Portland Mall', 'Carol Davis', 'Pacific Northwest', 4200, 'outlet', 7000.00, '2022-08-01', 3, '2024-09-30 17:00:00'); -- store closed

-- Store 103: New store with one update
INSERT INTO store_audit (store_id, store_name, manager_name, region, square_footage, store_type, monthly_rent, opened_date, audit_type, modified_at)
VALUES 
    (103, 'San Francisco Bay', 'David Martinez', 'Northern California', 6000, 'flagship', 25000.00, '2024-01-10', 1, '2024-01-10 08:00:00'),
    (103, 'San Francisco Bay', 'David Martinez', 'Northern California', 6000, 'flagship', 28000.00, '2024-01-10', 1, '2024-10-01 09:00:00'); -- rent increase

-- Store 104: No changes yet
INSERT INTO store_audit (store_id, store_name, manager_name, region, square_footage, store_type, monthly_rent, opened_date, audit_type, modified_at)
VALUES 
    (104, 'Austin Central', 'Emma Thompson', 'Southwest', 5500, 'standard', 11000.00, '2024-05-01', 1, '2024-05-01 10:00:00');



-- User 1001: Multiple relocations and device changes
INSERT INTO user_geolocation_audit (user_id, zip_code, city, state, country, device_type, device_os, browser, ip_address, is_vpn, modified_at)
VALUES 
    (1001, '10001', 'New York', 'New York', 'USA', 'desktop', 'Windows 11', 'Chrome', '192.168.1.100', FALSE, '2023-03-01 12:00:00'),
    (1001, '10001', 'New York', 'New York', 'USA', 'mobile', 'iOS 16', 'Safari', '192.168.1.101', FALSE, '2023-05-15 08:30:00'), -- got new phone
    (1001, '94102', 'San Francisco', 'California', 'USA', 'mobile', 'iOS 17', 'Safari', '10.0.0.50', FALSE, '2024-01-20 14:00:00'), -- moved to SF + OS update
    (1001, '94102', 'San Francisco', 'California', 'USA', 'desktop', 'macOS', 'Chrome', '10.0.0.51', FALSE, '2024-08-10 09:00:00'); -- new computer

-- User 1002: VPN usage and international travel
INSERT INTO user_geolocation_audit (user_id, zip_code, city, state, country, device_type, device_os, browser, ip_address, is_vpn, modified_at)
VALUES 
    (1002, '98101', 'Seattle', 'Washington', 'USA', 'desktop', 'macOS', 'Firefox', '172.16.0.10', FALSE, '2023-06-01 10:00:00'),
    (1002, '98101', 'Seattle', 'Washington', 'USA', 'desktop', 'macOS', 'Firefox', '203.0.113.42', TRUE, '2023-09-12 15:30:00'), -- started using VPN
    (1002, 'SW1A 1AA', 'London', 'England', 'UK', 'mobile', 'Android 13', 'Chrome', '198.51.100.20', FALSE, '2024-02-14 07:00:00'), -- temporary relocation
    (1002, '98101', 'Seattle', 'Washington', 'USA', 'desktop', 'macOS', 'Firefox', '203.0.113.42', TRUE, '2024-03-01 11:00:00'); -- returned home

-- User 1003: Simple device upgrade
INSERT INTO user_geolocation_audit (user_id, zip_code, city, state, country, device_type, device_os, browser, ip_address, is_vpn, modified_at)
VALUES 
    (1003, '60601', 'Chicago', 'Illinois', 'USA', 'mobile', 'Android 12', 'Chrome', '198.18.0.30', FALSE, '2023-11-05 13:00:00'),
    (1003, '60601', 'Chicago', 'Illinois', 'USA', 'mobile', 'Android 14', 'Chrome', '198.18.0.30', FALSE, '2024-09-22 16:45:00'); -- OS upgrade

-- User 1004: Frequent traveler
INSERT INTO user_geolocation_audit (user_id, zip_code, city, state, country, device_type, device_os, browser, ip_address, is_vpn, modified_at)
VALUES 
    (1004, '33139', 'Miami', 'Florida', 'USA', 'tablet', 'iOS 16', 'Safari', '192.0.2.10', FALSE, '2024-01-15 09:00:00'),
    (1004, '75001', 'Paris', 'Île-de-France', 'France', 'tablet', 'iOS 16', 'Safari', '198.51.100.100', FALSE, '2024-02-20 06:00:00'), -- travel
    (1004, '28001', 'Madrid', 'Madrid', 'Spain', 'tablet', 'iOS 16', 'Safari', '203.0.113.75', FALSE, '2024-03-05 10:30:00'), -- more travel
    (1004, '33139', 'Miami', 'Florida', 'USA', 'tablet', 'iOS 17', 'Safari', '192.0.2.10', FALSE, '2024-04-01 14:00:00'); -- back home + update

-- User 1005: No changes yet
INSERT INTO user_geolocation_audit (user_id, zip_code, city, state, country, device_type, device_os, browser, ip_address, is_vpn, modified_at)
VALUES 
    (1005, '02101', 'Boston', 'Massachusetts', 'USA', 'desktop', 'Windows 11', 'Edge', '198.18.5.25', FALSE, '2024-07-01 11:30:00');

