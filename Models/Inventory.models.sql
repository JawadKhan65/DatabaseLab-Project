use Project

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
-- Procedure to Create Inventory with Validations
CREATE PROCEDURE createInventory
	@user_id INT,
	@product_name VARCHAR(255),
	@category VARCHAR(255),
	@quantity INT,
	@price DECIMAL(10,2)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE id = @user_id)
    BEGIN
		SELECT 0 AS success, 'User does not exist' AS message;
		RETURN;
	END

	INSERT INTO inventory
		(user_id, product_name, category, quantity, price)
	VALUES
		(@user_id, @product_name, @category, @quantity, @price);

	SELECT 1 AS success, 'Inventory created successfully' AS message;
END;
GO
-- Procedure to Retrieve Inventory
CREATE PROCEDURE getInventories
	@user_id INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE id = @user_id)
    BEGIN
		SELECT 0 AS success, 'User does not exist' AS message;
		RETURN;
	END

	SELECT *
	FROM inventory
	WHERE user_id = @user_id;
END;
GO
-- Procedure to Update Inventory with Validations
CREATE PROCEDURE updateInventory
	@user_id INT,
	@inventory_id INT,
	@product_name VARCHAR(255),
	@category VARCHAR(255),
	@quantity INT,
	@price DECIMAL(10,2)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM inventory
	WHERE id = @inventory_id AND user_id = @user_id)
    BEGIN
		SELECT 0 AS success, 'Inventory not found or permission denied' AS message;
		RETURN;
	END

	UPDATE inventory
    SET product_name = @product_name, category = @category, quantity = @quantity, price = @price, last_updated = GETDATE()
    WHERE id = @inventory_id;

	SELECT 1 AS success, 'Inventory updated successfully' AS message;
END;
GO
-- Procedure to Delete Inventory with Validation
CREATE PROCEDURE deleteInventory
	@user_id INT,
	@inventory_id INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM inventory
	WHERE id = @inventory_id AND user_id = @user_id)
    BEGIN
		SELECT 0 AS success, 'Inventory not found or permission denied' AS message;
		RETURN;
	END

	DELETE FROM inventory WHERE id = @inventory_id;
	SELECT 1 AS success, 'Inventory deleted successfully' AS message;
END;
GO