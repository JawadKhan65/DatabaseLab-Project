use Project

CREATE TABLE OtherInventory (
    id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    quantity INT NOT NULL CHECK (quantity >= 0),
    price DECIMAL(10,2) NOT NULL,
	user_id int not null,
    last_updated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade on update cascade
);


--- for other inventory

create procedure createOtherInventory
	@user_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price int

as 
begin
insert into OtherInventory(user_id,product_name,category,quantity,price)
 values
 (@user_id,@product_name,@category,@quantity,@price)
	
end




create procedure getOtherInventory
	@user_id int,
	@inventory_id int

as 
begin
	if exists(
		select 1 from OtherInventory O
		left join inventory_permissions IP on IP.inventory_id=O.id
		where O.id= @inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id and IP.permission_type='writeSecondary'))
	)
	begin
		select * from OtherInventory
		where id=@inventory_id
	end
	else
	begin
	select 0 as success
	end
end

create procedure updateOtherInventory
	@user_id int,
	@inventory_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price int
as
begin
	if exists(
		select 1 from OtherInventory O
		left join inventory_permissions IP on IP.inventory_id = O.id
		where O.id=@inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id) and IP.permission_type = 'writeSecondary')
	)
	begin
	Update OtherInventory
	set product_name=@product_name, category=@category,quantity=@quantity,price=@price,last_updated=GETDATE()
	where id=@inventory_id
	end
	else
	begin
	select 0 as success
	end
end




create procedure deleteOtherInventory
	@user_id int,
	@inventory_id int
as
begin
	if exists(
		select 1 from OtherInventory O 
		left join inventory_permissions IP on IP.inventory_id = O.id
		where O.id=@inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id and IP.permission_type='writeSecondary'))
	)
	begin
		select 1 as success
	end
	else
	begin
	select 0 as success
	end
end

