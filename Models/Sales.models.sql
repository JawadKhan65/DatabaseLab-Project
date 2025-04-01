USE Project;

-- Sales Table

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
-- Procedure to Create Sale
CREATE PROCEDURE createSale
	@supplier_id INT,
	@order_id INT,
	@user_id INT,
	@total_amount DECIMAL(15,2),
	@saleType VARCHAR(30)
AS
BEGIN
	INSERT INTO sales
		(supplier_id, user_id, order_id, total_amount, saleType)
	VALUES
		(@supplier_id, @user_id, @order_id, @total_amount, @saleType);

	SELECT 1 AS success, 'Sale created successfully.' AS message;
END;
GO
-- Procedure to Delete Sale
CREATE PROCEDURE deleteSale
	@user_id INT,
	@order_id INT,
	@sale_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM sales
	WHERE user_id = @user_id AND order_id = @order_id AND id = @sale_id
    )
    BEGIN
		DELETE FROM sales
        WHERE user_id = @user_id AND order_id = @order_id AND id = @sale_id;

		SELECT 1 AS success, 'Sale deleted successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Sale not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Get Sales
CREATE PROCEDURE getSales
	@user_id INT
AS
BEGIN
	SELECT *
	FROM sales
	WHERE user_id = @user_id;
END;
GO
-- Procedure to Update Sale
CREATE PROCEDURE updateSale
	@user_id INT,
	@order_id INT,
	@sale_id INT,
	@total_amount DECIMAL(15,2),
	@sale_type VARCHAR(30)
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM sales
	WHERE user_id = @user_id AND order_id = @order_id AND id = @sale_id
    )
    BEGIN
		UPDATE sales
        SET saleType = @sale_type, total_amount = @total_amount
        WHERE user_id = @user_id AND order_id = @order_id AND id = @sale_id;

		SELECT 1 AS success, 'Sale updated successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Sale not found or access denied.' AS message;
	END
END;
GO