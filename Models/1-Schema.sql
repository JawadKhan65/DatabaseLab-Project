
use master

drop database Project

IF  EXISTS (SELECT name
FROM sys.databases
WHERE name = 'Project')
BEGIN
    drop database Project
    CREATE DATABASE Project
    USE Project
END
else
begin
    create database Project
    USE Project
end

GO



create table users
(
    id int primary key identity(1,1),
    firstName varchar(255) not null,
    lastName varchar(255) not null,
    email varchar(255) unique not null,
    phone varchar(15) not null check (phone LIKE '+%-%-%'),
    password_hash varchar(255) not null,
    role varchar(20) not null check (role IN ('admin', 'employee', 'manager')),
    created_at DATETIME default GETDATE()
)
GO

create table suppliers
(
    id int primary key identity(1,1),
    user_id int,
    name varchar(255) not null,
    email varchar(255),
    phone varchar(20),
    address varchar(max),
    foreign key (user_id) references users(id)
)
GO



create table inventory
(
    id int primary key identity(1,1),
    user_id int not null,
    product_name varchar(255) not null,
    category varchar(255),
    quantity int not null check (quantity >= 0),
    price decimal(10,2) not null,
    last_updated DATETIME default GETDATE(),
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO


create table inventory_permissions
(
    id int primary key identity(1,1),
    user_id int not null,
    inventory_id int not null,
    permission_type varchar(50) not null check (permission_type in ('readPrimary','writePrimary','readSecondary','writeSecondary')),
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION,
    foreign key (inventory_id) references inventory(id) on delete CASCADE on update CASCADE
)
GO



create table OtherInventory
(
    id int primary key identity(1,1),
    product_name varchar(255) not null,
    category varchar(255),
    quantity int not null check (quantity >= 0),
    price decimal(10,2) not null,
    user_id int not null,
    last_updated DATETIME default GETDATE(),
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO



create table departments
(
    id int primary key identity(1,1),
    user_id int not null,
    name varchar(255) unique not null,
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO

create table budget
(
    id int primary key identity(1,1),
    user_id int not null,
    department_id int not null,
    allocated_amount decimal(15,2) not null,
    spent_amount decimal(15,2) default 0,
    created_at DATETIME default GETDATE(),
    foreign key (department_id) references departments(id) on delete cascade on update cascade,
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO



create table expenses
(
    id int primary key identity(1,1),
    user_id int not null,
    category varchar(255) not null,
    amount decimal(15,2) not null,
    description varchar(max),
    department_id int not null,
    date DATETIME default GETDATE(),
    foreign key (department_id) references departments(id) on delete cascade on update cascade,
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO



create table orders
(

    id int primary key identity(1,1),
    user_id int not null,
    supplier_id int not null,
    total_amount decimal(15,2) not null,
    order_date DATETIME default GETDATE(),
    status varchar(50) default 'pending' CHECK (status IN ('pending', 'completed', 'canceled')),
    foreign key (supplier_id) references suppliers(id) on delete no action on update cascade,
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO

create table dispatch
(

    id int primary key identity(1,1),
    user_id int not null,
    order_id int not null,
    dispatch_date DATETIME default GETDATE(),
    status VARCHAR(50) default 'pending' CHECK (status IN ('pending', 'dispatched', 'delivered')),
    foreign key (order_id) references orders(id),
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO



create table sales
(
    id int primary key identity(1,1),
    supplier_id int,
    order_id int unique,
    -- One sale per order
    total_amount decimal(15,2) not null,
    user_id int not null,
    sale_date DATETIME default GETDATE(),
    saleType varchar(30) default 'cash' CHECK (saleType IN ('cash', 'credit')),
    foreign key (supplier_id) references suppliers(id) on delete set null,
    foreign key (order_id) references orders(id) on delete cascade on update cascade,
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO


create table sale_details
(
    id int primary key identity(1,1),
    user_id int not null,
    sale_id int not null,
    inventory_id int not null,
    quantity int not null,
    price DECIMAL(10,2) not null,
    foreign key (sale_id) references sales(id) on delete NO ACTION on update NO ACTION,
    foreign key (inventory_id) references inventory(id) on delete NO ACTION on update NO ACTION,
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO


create table purchases
(
    id int primary key identity(1,1),
    user_id int not null,
    supplier_id int not null,
    total_amount decimal(15,2) not null,
    purchase_date DATETIME default GETDATE(),
    foreign key (supplier_id) references suppliers(id) on delete cascade on update cascade,
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO

create table accounts
(
    id int primary key IDENTITY(1,1),
    user_id int not null,
    account_name varchar(255) not null,
    balance decimal(15,2) not null,
    last_transaction_date DATETIME default GETDATE(),
    foreign key (user_id) references users(id) ON delete cascade on update cascade
)
GO