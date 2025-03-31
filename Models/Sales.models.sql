use Project
CREATE TABLE sales (
    id INT PRIMARY KEY IDENTITY(1,1),
    supplier_id INT,
    order_id INT UNIQUE, -- One sale per order
    total_amount DECIMAL(15,2) NOT NULL,
	user_id int not null,
    sale_date DATETIME DEFAULT GETDATE(),
    saleType VARCHAR(30) DEFAULT 'cash' CHECK (saleType IN ('cash', 'credit')),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);




-- Procedure to Create Sale
CREATE PROCEDURE createSale
    @supplier_id INT ,
    @order_id INT,
	@user_id int,
    @total_amount DECIMAL(15,2),
    @saleType VARCHAR(30)
AS
BEGIN
    INSERT INTO sales (supplier_id,user_id, order_id, total_amount, saleType)
    VALUES (@supplier_id,@user_id, @order_id, @total_amount, @saleType);
END

create procedure deleteSale
	@user_id int,
	@order_id int,
	@sale_id int
as 
begin
	delete from sales
	where user_id=@user_id and order_id =@order_id and id=@sale_id
end
create procedure getSales
	@user_id int,
as
begin
	select * from sales
	where user_id =@user_id
end


create procedure updateSale
	@user_id int,
	@order_id int,
	@sale_id int,
	@total_amount decimal(15,2),
	@sale_type varchar(255)
as 
begin
	update sales
	set sale_type = @sale_type , total_amount=@total_amount
	where user_id=@user_id and order_id =@order_id and id=@sale_id
end




