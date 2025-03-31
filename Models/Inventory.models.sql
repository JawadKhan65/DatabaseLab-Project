use Project


CREATE TABLE inventory (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    quantity INT NOT NULL CHECK (quantity >= 0),
    price DECIMAL(10,2) NOT NULL,
    last_updated DATETIME DEFAULT GETDATE(),
    foreign key (user_id) references  users(id) on delete cascade on update cascade
);



-- Procedures for Inventory Management

create procedure createInventory
	@user_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price decimal(10,2)
as
begin
 insert into inventory(user_id,product_name,category,quantity,price)
 values
 (@user_id,@product_name,@category,@quantity,@price)
end



create procedure getInventories
	@user_id int
	
as

begin
	if exists(
	select 1 from inventory I
	left join  inventory_permissions IP on I.id = IP.inventory_id
	where I.user_id=@user_id
	and (I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type='writePrimary') )
	
	)
	begin 
		select * from inventory
		
	end
	else
	begin 
		select 0 as success
	end
end






create procedure updateInventory
	@user_id int,
	@inventory_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price decimal(10,2)
as 
begin
	if exists(
		select 1 from inventory I
		left join inventory_permissions IP on IP.inventory_id = I.id
		where I.id = @inventory_id
		And ( I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type = 'writePrimary'))
	)
	begin
		update inventory
		set product_name=@product_name,category=@category,quantity=@quantity,price=@price,last_updated=GETDATE()
		where id=@inventory_id 
		--return something back for handling
		select 1 as 'success'
	end
	ELSE
    BEGIN
        SELECT 0 AS 'success'
    END
	
end





create procedure deleteInventory
	@user_id int,
	@inventory_id int
as 
begin
	if exists(
		select 1 from inventory I
		left join inventory_permissions IP on IP.inventory_id = I.id
		where I.id = @inventory_id
		And ( I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type = 'writePrimary'))
	)
	begin
		delete from inventory
		where id=@inventory_id 
		--return something back for handling
		select 1 as 'success'
	end
	ELSE
    BEGIN
        SELECT 0 AS 'success'
    END
	
end


