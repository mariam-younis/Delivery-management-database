#database creation
create database delivery_system;
use delivery_system;

#tables creation
create table item (
  item_code char(3) primary key,
  name varchar(30),
  price decimal(6,2) not null,
  category varchar(30)
);
desc item;

create table customer(
  username varchar(20) primary key,
  first_name varchar(30) not null,
  last_name varchar (30) not null,
  DOB date,
  email varchar(50) unique,
  building varchar(20),
  street varchar(20),
  city varchar(20) not null
);
desc customer;

create table driver (
  driver_ID char(6) primary key,
  first_name varchar(30) not null,
  last_name varchar (30) not null,
  DOB date,
  licence_plate varchar(10) unique,
  building varchar(20),
  street varchar(20),
  city varchar(20) not null,
  phone_number char(10)
);
desc driver;

create table order_(
  order_ID char(6) primary key,
  timestamp timestamp,
  delivery_status varchar(20),
  customer_username varchar(20) not null,
  driver_ID char(6) not null,
  constraint delivery_status_check check (delivery_status in ('pending', 'in transit', 'delivered', 'cancelled')),
  constraint order_customer_FK foreign key (customer_username) references customer (username) on update cascade on delete restrict,
  constraint order_driver_FK foreign key (driver_ID) references driver (driver_ID) on update restrict on delete restrict
);
desc order_;
alter table order_
add notes varchar(500);

create table payment(
  payment_ID char(6) primary key,
  confirmation boolean not null,
  amount decimal(6,2) not null,
  order_ID char(6) unique not null,
  constraint payment_order_FK foreign key(order_ID) references order_ (order_ID) on delete restrict on update restrict
);
alter table payment 
drop  constraint payment_order_FK,
add constraint payment_order_FK foreign key(order_ID) references order_ (order_ID) on delete cascade on update restrict,
add method varchar(10) ,
add constraint payment_method_check check (method in ('cash','card'));
desc payment;

create table order_items(
  order_ID char(6),
  item_code char(3),
  quantity int not null, 
  constraint order_items_PK primary key (order_ID, item_code),
  constraint item_quantity_check check (quantity > 0),
  constraint orderID_items_FK foreign key(order_ID) references order_ (order_ID) on delete restrict on update restrict,
  constraint order_itemCode_FK foreign key(item_code) references item (item_code) on delete restrict on update restrict
);
alter table order_items
drop constraint orderID_items_FK ,
drop constraint order_itemCode_FK,
add constraint orderID_items_FK foreign key(order_ID) references order_ (order_ID) on delete cascade on update restrict,
add constraint order_itemCode_FK foreign key(item_code) references item (item_code) on delete cascade on update restrict;
desc order_items;

create table customer_phone(
  customer_username varchar(20),
  phone_number char(10),
  constraint customer_phone_PK primary key (customer_username, phone_number) ,
  constraint customer_phone_FK foreign key (customer_username) references customer(username) on delete restrict on update cascade
);
desc customer_phone;

#data insertion
insert into item 
values('001','beef burger',6.50,'main course'),
('002','chicken burger',5.50,'main course'),
('003',' burger',5.50,'main course'),
('004','vegeterian pizza',4.50,'main course'),
('005','pepperoni pizza',5.00,'main course'),
('006','margherita pizza',4.25,'main course'),
('007','french fries',2.25,'appetizer'),
('008','curly fries',2.75,'appetizer'),
('009','mozzarella sticks-4 pieces',3.75,'appetizer'),
('010','ceasar salad',4.00,'appetizer'),
('011','onion rings',3.00,'appetizer'),
('012','lemon juice',1.50,'drinks'),
('013','apple juice',1.50,'drinks'),
('014','orange juice',1.50,'drinks'),
('015','soft drink',1.00,'drinks'),
('016','water',0.50,'drinks'),
('017','cookie',1.25,'dessert'),
('018','choclate cupcake',1.50,'dessert'),
('019','vanilla cupcake',1.50,'dessert'),
('020','brownies',3.00,'dessert');
update item 
set name ='vegan burger' where item_code='003';

insert into customer 
values ('ahmadAli_12','ahmad','ali','2000-10-29',null,'2','Mecca street','amman'),
('salma00','salma','omar','2002-05-08','salmaOmarr@gmail.com','55','Airport road','amman'),
('sabaa432','saba','mahmoud','1999-11-17',null,'12','Wasfi Al-Tal Street','amman'),
('ibrahim_samer1','ibrahim','samer',null,'ibrahimsamer91@gmail.com','9','Rainbow street','amman'),
('lamarrr23a','lamar','jameel','2005-01-11','lamar333j@gmail.com','34','University street','irbid'),
('zaina_0','zaina','amer','2004-06-15',null,'18','Palestine Street ','irbid');

insert into driver 
values('110272','omar','hamdi','1997-10-10','66-87819','1','Almanhal street','amman','0796772152'),
('372928','osama','yousef','2000-11-28','32-72610','16','Third circle street','amman','0795831238'),
('144202','jamal','nabeel',null,'18-80301','35',null,'irbid','0774504998'),
('215400','khalid','mousa','1995-04-12','45-99201','12','Mecca street','amman','0770678541'),
('582104','tariq','ziad','1999-08-23','81-30492', '8','University street','irbid','0777916938'),
('301984','hassan','fayed','1993-12-05','19-55102','44','Hashimi street','zarqa','0799236555');

insert into order_
values('111011',now(),'pending','salma00','110272','please add extra cheese to the burger'),
('151014',now(),'in transit','zaina_0','144202',null),
('291013',now(),'delivered','ibrahim_samer1','372928',null),
('402911', now(),'pending','ahmadAli_12','215400','call upon arrival'),
('510293', now(),'in transit','sabaa432','582104','leave at the main door'),
('639102', now(),'delivered','lamarrr23a','301984',null),
('781045', now(),'cancelled','salma00','110272',null);
 
 insert into order_items
 values('111011','001',2),
('111011','015',2),
('111011','007',1),
('151014','018',5),
('151014','019',5),
('291013','004',1),
('291013','005',1),
('291013','006',1),
('291013','013',2),
('402911','002',2),
('402911','008',1), 
('402911','012',2), 
('510293','005',2), 
('510293','009',1), 
('510293','015',2), 
('639102','010',1), 
('639102','006',1), 
('639102','016',2), 
('639102','020',1), 
('781045','001',1), 
('781045','007',1), 
('781045','014',1);

insert into customer_phone
values('zaina_0','0798785401'),
('ibrahim_samer1','0798700402'),
('ibrahim_samer1','0797621182'),
('lamarrr23a','0786778655'),
('sabaa432','0780098231'),
('sabaa432','0771100778'),
('ahmadAli_12','0796805929'),
('salma00','0790700694');

insert into payment 
values('PAY001', 1, 17.25, '111011', 'Card'),
('PAY002', 1, 15.00, '151014', 'Cash'),
('PAY003', 1, 19.75, '291013', 'Card'),
('PAY004', 1, 16.75, '402911', 'Card'),
('PAY005', 1, 15.75, '510293', 'Cash'),
('PAY006', 1, 12.25, '639102', 'Card'),
('PAY007', 0, 10.25, '781045', 'Cash');
update payment 
set confirmation = 0;
update payment
set confirmation =1
where order_ID='291013' 
 or order_ID= '639102';
 select *from payment;
 
#views creation
create view payment_amount_check
as 
select o.order_ID,o.timestamp,p.amount,sum(oi.quantity*i.price) as order_total_price
from payment p
join order_ o
on p.order_ID=o.order_ID
join order_items oi 
on o.order_ID=oi.order_ID
join  item i
on i.item_code=oi.item_code
group by order_ID;
SELECT * FROM payment_amount_check;

create view driver_accepted_orders
as
select d.driver_ID,concat(d.first_name,' ',d.last_name)as full_name,count(o.order_ID) as orders_accepted
from driver d
join order_ o
on d.driver_ID=o.driver_ID
group by d.driver_ID
order by orders_accepted desc;
select * from driver_accepted_orders;

create view customer_contact_information
as 
select concat(c.first_name,' ',c.last_name) as full_name,cp.phone_number,c.email
from customer c
join customer_phone cp
on c.username=cp.customer_username
order by full_name;
select *from customer_contact_information;

create view items_sales
as
select i.name,i.price as unit_price,sum(i.price*oi.quantity) as revenue 
from  item i
join order_items oi
on i.item_code=oi.item_code
group by i.name,i.price
order by revenue desc;

#procedures creation
delimiter \\
create procedure alter_item_price(in percentage decimal(3,3),INitem_code char(3))
begin 
 select item_code,name,price from item where item_code=INitem_code;
 update item 
 set price= price*(1+percentage)
 where item_code=INitem_code;
 select item_code,name,price from item where item_code=INitem_code;
end \\
delimiter ;
call alter_item_price(0.1,'003');
call alter_item_price(-0.1,'004');
call alter_item_price(0.2,'002');
call alter_item_price(-0.2,'002');
call alter_item_price(0.5,'010');
delimiter \\
create procedure payment_confirmation(in INorder_ID char(6))
begin
 update order_
 set delivery_status='delivered'
 where order_ID=INorder_ID;
 update payment 
 set confirmation=1
 where order_ID=INorder_ID and method is not null;
 select p.order_ID,p.method,o.delivery_status,p.confirmation
 from payment p
 join order_ o
 on p.order_ID=o.order_ID
 where p.order_ID=Inorder_ID;
end \\
delimiter ;
call payment_confirmation('151014');

delimiter \\
create procedure update_customer_profile(in INusername varchar(20), INbuilding varchar(20),INstreet varchar(20), INcity varchar(20))
begin 
update customer 
set  building=INbuilding, street=INstreet, city=INcity
where username=INusername;
select *from customer 
where username=INusername;
end \\
delimiter ;
call update_customer_profile('salma00','50','Madina street','amman');

delimiter \\
create procedure update_driver_profile(in INdriver_ID char(6), INbuilding varchar(20),INstreet varchar(20), INcity varchar(20))
begin 
update driver 
set  building=INbuilding, street=INstreet, city=INcity
where driver_ID=INdriver_ID;
select *from driver
where driver_ID=INdriver_ID;
end \\
delimiter ;
call update_driver_profile('144202','33','Downtown street','amman');

delimiter \\
create procedure create_order(in INorder_ID char(6),INcustomer_username varchar(20),INnotes varchar(500))
begin
    insert into order_ (order_ID, timestamp, delivery_status, customer_username, driver_ID, notes)
    values (INorder_ID, now(), 'pending', INcustomer_username, (select driver_ID from driver order by rand() limit 1),INnotes);
    select * from order_ where order_ID = INorder_ID;
end \\
delimiter ;
call create_order('755920','zaina_0',null);
call create_order('755320','zaina_0',null);
delimiter \\
create procedure add_order_item(in INorder_ID char(6),INitem_code char(3),INquantity int)
begin
    insert into order_items (order_ID, item_code, quantity)
    values (INorder_ID, INitem_code, INquantity);
    select * from order_items where order_ID = INorder_ID and item_code = INitem_code;
end \\
delimiter ;
call add_order_item('755920','021',4);
insert into payment 
values('PAY019',0,10.00,'755920','card');

#data validation 
insert into item 
values (null,'sauce',0.75,'main course');
insert into item 
values ('001','sauce',0.75,'main course');
update driver 
set licence_plate='18-80301'
where driver_ID='215400';
update customer
set city=null
where username='salma00';
update payment 
set method='bank card'
where payment_ID='PAY001';
insert into driver 
values ('228719','abdallah','saleem','0','65-14526',null,null,'irbid','0786211844');
delete from driver 
where driver_ID='110272';
select *from customer;
update order_
set order_ID='123456'
where order_ID='111011';
update customer 
set username='salmaaa2'
where username='salmaaa0';
select order_ID,customer_username from order_
where customer_username='salmaaa2';
delete from order_
where order_ID='111011';
select payment_ID,order_ID 
from payment 
where order_ID='111011';
insert into item 
values ('0011','chocalate cake with strawberry  ',null,null);

#user creation
select user ();

create user 'customer'@'localhost'
identified by 'customer123';
grant select on delivery_system.item to 'customer'@'localhost';
grant execute on procedure update_customer_profile to 'customer'@'localhost';
grant execute on procedure create_order to 'customer'@'localhost';
grant execute on procedure add_order_item to 'customer'@'localhost';
grant select, insert on delivery_system.order_ to 'customer'@'localhost';
create user 'driver'@'localhost'
identified by 'driver123';
grant execute on procedure payment_confirmation to 'driver'@'localhost';
grant execute on procedure update_driver_profile to 'driver'@'localhost';
grant select on delivery_system.customer_contact_information to 'driver'@'localhost';

create user 'admin'@'localhost'
identified by 'admin123';
grant select on delivery_system.* to 'admin'@'localhost'with grant option;
grant select,update, insert,delete on delivery_system.driver to 'admin'@'localhost';
grant select,update, insert,delete on delivery_system.item to 'admin'@'localhost';
grant execute on procedure alter_item_price to 'admin'@'localhost';









