
Database Architecture & Schema
The database consists of 7 interconnected tables with enforced primary keys, foreign keys, cascade rules, and check constraints:
item: Menu items with pricing and category classification.
customer: User account profile and location data.
driver: Delivery personnel details, license tracking, and contact info.
order_: Central order records linking customers to assigned drivers with delivery status validation (pending, in transit, delivered, cancelled).
payment: Payment tracking linked 1:1 with orders, validating payment method (cash, card) and confirmation state.
order_items: Junction table for the many-to-many relationship between orders and items, enforcing positive quantities.
customer_phone: Normalizes multivalued phone numbers per customer profile.
Technical Features
1. Data Integrity & Validation
Constraints: Enforces data domain bounds using CHECK constraints (e.g., quantity > 0, fixed payment methods, status restrictions).
Referential Integrity: Uses explicit foreign key behavior (ON DELETE CASCADE, ON DELETE RESTRICT, ON UPDATE CASCADE) to maintain database consistency.
2. Analytical Views
payment_amount_check: Aggregates total order item costs to verify against recorded payment amounts.
driver_accepted_orders: Calculates delivery volume metrics per driver.
customer_contact_information: Combines customer details with associated phone numbers for operational lookup.
items_sales: Tracks unit prices and aggregate revenue generated per menu item.
3. Automated Stored Procedures
alter_item_price(percentage, item_code): Dynamically adjusts item pricing by a percentage factor.
payment_confirmation(order_ID): Updates delivery status to delivered and confirms payment state.
update_customer_profile / update_driver_profile: Updates address data for users.
create_order(order_ID, customer_username, notes): Initializes an order and randomly assigns an available driver.
add_order_item(order_ID, item_code, quantity): Appends specific line items to an existing order.
4. Role-Based Access Control (RBAC)
Configured user roles and security privileges restricted by operational requirements:
customer: Read access to menu items; restricted execution rights for profile updates, order creation, and line item additions.
driver: Execution rights for payment confirmation and profile updates; read-only access to customer contact views.
admin: Full administrative management (SELECT, INSERT, UPDATE, DELETE) over drivers, menu items, and pricing procedures with grant permissions.

