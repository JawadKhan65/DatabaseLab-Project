use Project
-- 10. Orders
CREATE TABLE orders (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    supplier_id INT NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'canceled')),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) on delete  no action on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);




-- Procedure Orders

CREATE PROCEDURE createOrder
    @supplier_id INT,
	@user_id int,
    @total_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO orders (user_id,supplier_id, total_amount)
    VALUES (@user_id,@supplier_id, @total_amount);
END


create procedure deleteOrder
	@supplier_id int,
	@user_id int,
	@order_id int,
begin
	delete from orders 
	where user_id=@user_id and id=@order_id and supplier_id = @supplier_id
end

create procedure updateOrder
	@supplier_id int,
	@user_id int,
	@order_id int,
	@total_amount decimal(15,2)
as
begin
	update orders
	set total_amount=@total_amount
	where user_id=@user_id and id=@order_id and supplier_id = @supplier_id
end

create procedure getOrders
	@user_id int
as
begin
	select * from orders
	where user_id=@user_id
end

