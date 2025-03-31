use Project
CREATE TABLE suppliers (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT
	Foreign Key (user_id) references users(id)
);




CREATE PROCEDURE createSupplier
    @name VARCHAR(255),
	@user_id int,
    @email VARCHAR(255) = NULL,
    @phone VARCHAR(20) = NULL,
    @address TEXT = NULL
AS
BEGIN
    INSERT INTO suppliers (name,user_id, email, phone, address)
    VALUES (@name,@user_id, @email, @phone, @address);
END



create procedure updateSupplier
	@supplier_id int,
	@name VARCHAR(255),
	@user_id int,
    @email VARCHAR(255) = NULL,
    @phone VARCHAR(20) = NULL,
    @address TEXT = NULL
as 
begin
	if exists(
	select  1 from suppliers
	where id=@supplier_id and USER_ID=@user_id
	)
	begin
	update suppliers
	set name=@name,address=@address,email=@email,phone=@phone
	where id=@supplier_id and USER_ID=@user_id

	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end
end


create procedure deleteSupplier
	@supplier_id int,
	@user_id int
as 
begin
	if exists(
	select  1 from suppliers
	where id=@supplier_id  and user_id =@user_id
	)
	begin
	delete from suppliers
	where  id=@supplier_id  and user_id =@user_id

	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end
end

