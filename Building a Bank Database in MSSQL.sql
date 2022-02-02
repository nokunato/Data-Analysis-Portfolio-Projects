--drop database BankDMS_DB

create Database BDMS_DB;

use BDMS_DB;

'''SELECT [name] 
FROM master.dbo.sysdatabases 
WHERE dbid > 4'''

-- customer personal info (Create table)

create table customer_personal_info
(
customer_id varchar(5),
customer_name varchar(30),
Date_of_Birth Date,
Guardian_name Varchar(30),
Address varchar(50),
Contact_no bigint,
Mail_ID Varchar(30),
Gender Char(1),
Marital_Status varchar(10),
Identification_doc_type Varchar(20),
Id_doc_no Varchar(20),
Citizenship varchar(10),
constraint cust_pers_info_pk primary key(customer_id)
);

'''SELECT customer_personal_info
from BDMS_DB;'''
-- to change the table name use the Update function

--Create new table called customer reference info

create table customer_reference_info
(
customer_id varchar(5),
Reference_acc_name varchar(20),
Reference_acc_no bigint,
Reference_acc_address varchar(50),
Relation varchar(25),
constraint cust_ref_info_pk primary key(customer_id),
constraint cust_ref_info_fk foreign key(customer_id) references customer_personal_info (customer_id)
);

-- create bank info

create table Bank_info
(
IFSC_code varchar(15),
Bank_name varchar(25),
Branch_name varchar(25),
constraint Bank_info_pk primary key(IFSC_code)
);

-- create account info
create table Account_info
(
Account_no bigint,
BVN bigint,
customer_id varchar(5),
Account_type varchar(10),
Registration_date Date,
Activation_date Date,
IFSC_code Varchar(15),
Interest Decimal(7, 2),
Initial_deposit bigint,
constraint Acc_info_pk primary key(Account_no),
constraint Acc_info_pers_fk foreign key(customer_id) references customer_personal_info (customer_id),
constraint Acc_info_bank_fk foreign key(IFSC_code) references Bank_info (IFSC_code),
);

-- select * from dbo.Account_info
-- insert into table

insert into Bank_info(IFSC_code,Bank_name,Branch_name) values('HDVL0012', 'Access Bank', 'Jos street Branch')
select * from Bank_info