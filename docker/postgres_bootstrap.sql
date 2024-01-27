CREATE SCHEMA source;
CREATE SCHEMA dbt_stg;
CREATE SCHEMA dbt_prod;

-- default directory for every statement in this bootstrap
SET search_path TO source;

CREATE TYPE payment_enum AS ENUM ('Cash', 'Credit Card', 'Debit Card', 'Gift Card');
CREATE TABLE payment_type (
    id serial PRIMARY KEY,
    payment_type payment_enum,
    payment_type_description varchar(100),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

-- Create the sales data tables
CREATE TABLE customer (
    id serial PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp
);

CREATE TABLE source.order (
    id serial primary key,
    customer_id integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customer(id)
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
    invoice_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    financial_account_id integer,
    created_at timestamp default current_timestamp,
    modified_at timestamp default current_timestamp,
    CONSTRAINT fk_financial_account_id FOREIGN KEY (financial_account_id) REFERENCES financial_account(id),
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

INSERT INTO payment_type (payment_type, payment_type_description)
VALUES
    ('Cash', 'zz'),
    ('Credit Card', 'Electronics'),
    ('Gift Card', 'General Goods'),
    ('Debit Card', 'z');


INSERT INTO financial_account (financial_account_name, financial_account_type, financial_account_description)
VALUES 
    ('Cash', 'Asset', 'Account for Cash'),
    ('Accounts Receivable', 'Asset', 'Account for AR'),
    ('Sales Revenue', 'Revenue', 'Account for all Store Revenue'),
    ('Cost of Goods Sold', 'Expense', 'Account for COGS'),
    ('Operating Expenses', 'Expense', 'Account for General Expenses');

-- Insert some dummy data
INSERT INTO customer (customer_name, customer_email)
VALUES
    ('Johnny Allstar', 'customer1@example.com'),
    ('Aubrey Plaza', 'customer2@example.com'),
    ('John Wick', 'customer3@example.com');

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
    ('Blueberries', 1);

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

INSERT INTO source.order (id, customer_id)
VALUES 
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 3);


INSERT INTO order_detail (id, order_id, product_id, product_price_id, quantity)
VALUES
    (1, 1, 1, 1, 1),
    (2, 2, 1, 2, 1),
    (3, 2, 2, 3, 1),
    (4, 3, 4, 5, 1),
    (5, 4, 3, 4, 1);

INSERT INTO invoice (order_id, total_amount)
VALUES 
    (1, 15.99),
    (2, 61.98),
    (3, 21.98),
    (4, 3.99);

INSERT INTO payment (amount, payment_type_id, payment_type_detail, invoice_id, financial_account_id)
VALUES 
    (15.99, 1, NULL, 1, 3),
    (61.98, 2, '4436', 2, 3),
    (10.00, 3, 'G42423241', 3, 3);

INSERT INTO source.order_json (external_data)
VALUES
    ('{"id": 1, "source": {"address": "123 Wells Way", "store": "Walgreens", "state": "IL", "zip_code": 60601, "transaction_timestamp": "2023-09-17 20:00:00.000000"}, "sale_id": 4}');