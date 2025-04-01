USE Project;

-- Orders Table
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
-- Procedure: Create Order
CREATE PROCEDURE createOrder
	@supplier_id INT,
	@user_id INT,
	@total_amount DECIMAL(15,2)
AS
BEGIN
	INSERT INTO orders
		(user_id, supplier_id, total_amount)
	VALUES
		(@user_id, @supplier_id, @total_amount);

	-- Return the created order ID
	SELECT SCOPE_IDENTITY() AS order_id;
END;
GO
-- Procedure: Delete Order
CREATE PROCEDURE deleteOrder
	@supplier_id INT,
	@user_id INT,
	@order_id INT
AS
BEGIN
	DELETE FROM orders 
    WHERE user_id = @user_id AND id = @order_id AND supplier_id = @supplier_id;

	-- Check if deletion was successful
	IF @@ROWCOUNT > 0
        SELECT 1 AS success, 'Order deleted successfully' AS message;
    ELSE
        SELECT 0 AS success, 'Order not found or access denied' AS message;
END;
GO
-- Procedure: Update Order

CREATE PROCEDURE updateOrder
	@supplier_id INT,
	@user_id INT,
	@order_id INT,
	@total_amount DECIMAL(15,2),
	@status VARCHAR(50)
AS
BEGIN
	-- Check if the order exists and belongs to the user
	IF EXISTS (
        SELECT 1
	FROM orders
	WHERE user_id = @user_id AND id = @order_id AND supplier_id = @supplier_id
    )
    BEGIN
		UPDATE orders
        SET total_amount = ISNULL(@total_amount, total_amount)
        WHERE user_id = @user_id AND id = @order_id AND supplier_id = @supplier_id;

		SELECT 1 AS success, 'Order updated successfully' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Order not found or access denied' AS message;
	END
END;
GO
-- Procedure: Get Orders
CREATE PROCEDURE getOrders
	@user_id INT
AS
BEGIN
	SELECT *
	FROM orders
	WHERE user_id = @user_id;
END;
GO