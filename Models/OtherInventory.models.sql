USE Project;

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

-- Procedure: createOtherInventory
CREATE PROCEDURE createOtherInventory
	@user_id INT,
	@product_name VARCHAR(255),
	@category VARCHAR(255),
	@quantity INT,
	@price DECIMAL(10,2)
AS
BEGIN
	INSERT INTO OtherInventory
		(user_id, product_name, category, quantity, price)
	VALUES
		(@user_id, @product_name, @category, @quantity, @price);
	SELECT 1 AS success, 'Inventory Item Created' AS message;
END;
GO
-- Procedure: getOtherInventory
CREATE PROCEDURE getOtherInventory
	@user_id INT,
	@inventory_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM OtherInventory O
		LEFT JOIN inventory_permissions IP ON IP.inventory_id = O.id
	WHERE O.id = @inventory_id
		AND (O.user_id = @user_id OR (IP.user_id = @user_id AND IP.permission_type = 'writeSecondary'))
    )
    BEGIN
		SELECT *
		FROM OtherInventory
		WHERE id = @inventory_id;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Access Denied or Inventory Not Found' AS message;
	END
END;
GO
-- Procedure: updateOtherInventory
CREATE PROCEDURE updateOtherInventory
	@user_id INT,
	@inventory_id INT,
	@product_name VARCHAR(255),
	@category VARCHAR(255),
	@quantity INT,
	@price DECIMAL(10,2)
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM OtherInventory O
		LEFT JOIN inventory_permissions IP ON IP.inventory_id = O.id
	WHERE O.id = @inventory_id
		AND (O.user_id = @user_id OR (IP.user_id = @user_id AND IP.permission_type = 'writeSecondary'))
    )
    BEGIN
		UPDATE OtherInventory
        SET product_name = @product_name, category = @category, quantity = @quantity, price = @price, last_updated = GETDATE()
        WHERE id = @inventory_id;
		SELECT 1 AS success, 'Inventory Updated Successfully' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Access Denied or Inventory Not Found' AS message;
	END
END;
GO
-- Procedure: deleteOtherInventory
CREATE PROCEDURE deleteOtherInventory
	@user_id INT,
	@inventory_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM OtherInventory O
		LEFT JOIN inventory_permissions IP ON IP.inventory_id = O.id
	WHERE O.id = @inventory_id
		AND (O.user_id = @user_id OR (IP.user_id = @user_id AND IP.permission_type = 'writeSecondary'))
    )
    BEGIN
		DELETE FROM OtherInventory WHERE id = @inventory_id;
		SELECT 1 AS success, 'Inventory Deleted Successfully' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Access Denied or Inventory Not Found' AS message;
	END
END;
GO