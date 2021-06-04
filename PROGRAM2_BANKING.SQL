create database banking_enterprise;
use banking_enterprise;
create table branch(
 branch_name varchar(30) primary key,
 branch_city varchar(30),
 assets real
);
create table accounts(
 accno int primary key,
 branch_name varchar(30),
 balance real,
 constraint acc_bn foreign key (branch_name) references branch(branch_name) on delete cascade on update cascade
);

create table customer(
 customer_name  varchar(30) primary key,
 customer_street varchar(20),
 customer_city varchar(20)
);
create table depositor(
 customer_name  varchar(30),
 accno int,
 constraint cac_bn foreign key (accno) references accounts(accno) on delete cascade on update cascade,
 constraint ccn_bn foreign key (customer_name) references customer(customer_name) on delete cascade on update cascade
);

create table loan(
 loan_number int primary key,
 branch_name varchar(30),
 amount real,
 constraint l_bn foreign key (branch_name) references branch(branch_name)
);
 
insert into branch values('branchA','banglore',35565);
insert into branch values('branchB','gurugram',75363);
insert into branch values('branchC','delhi',23534);
insert into branch values('branchD','chennai',75332);
insert into branch values('branchE','gurugram',97644);

insert into accounts values(1,'branchA',44353); 
insert into accounts values(2,'branchB',46546); 
insert into accounts values(3,'branchA',44353);
insert into accounts values(4,'branchC',64252);
insert into accounts values(5,'branchD',72454);
select * from customer where customer_name in(select customer_name from depositor group by customer_name having count(accno)>=2);
insert into customer values('customer1','banglore','banglore');
insert into customer values('customer2','gurugram','gurugram');
insert into customer values('customer3','delhi','delhi');
insert into customer values('customer4','banglore','banglore');
insert into customer values('customer5','chennai','chennai');

insert into depositor values ('customer1',1);
insert into depositor values ('customer2',2);
insert into depositor values ('customer3',3);
insert into depositor values ('customer1',4);
insert into depositor values ('customer4',5);

insert into loan values(1,'branchA',10000);
insert into loan values(2,'branchD',20000);
insert into loan values(3,'branchC',30000);
insert into loan values(4,'branchA',30000);
insert into loan values(5,'branchC',30000);

select * from depositor;
-- Find all the customers who have at least two accounts at the Main branch

select * from customer where customer_name in(select customer_name from depositor group by customer_name having count(accno)>=2);

-- Find all the customers who have an account at all the branches located in a specific city.

select customer_name from depositor where accno in (select a.accno from accounts a,branch b where b.branch_name=b.branch_city );

select customer_name from depositor d,
accounts a where d.accno=a.accno and branch_name in 
(select branch_name as branch_name from branch where branch_city='Delhi')
 group by customer_name having count(*)=(select count(branch_name) 
 as branch_name from branch where branch_city='Delhi');


-- Demonstrate how you delete all account tuples at every branch located in a specific city.

delete from accounts where branch_name='banglore';
