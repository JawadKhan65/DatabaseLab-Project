USE Project;

-- Suppliers Table
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

-- Procedure to Create Supplier
CREATE PROCEDURE createSupplier
	@name VARCHAR(255),
	@user_id INT,
	@email VARCHAR(255) = NULL,
	@phone VARCHAR(20) = NULL,
	@address TEXT = NULL
AS
BEGIN
	INSERT INTO suppliers
		(name, user_id, email, phone, address)
	VALUES
		(@name, @user_id, @email, @phone, @address);

	SELECT 1 AS success, 'Supplier created successfully.' AS message;
END
GO

-- Procedure to Update Supplier
CREATE PROCEDURE updateSupplier
	@supplier_id INT,
	@name VARCHAR(255),
	@user_id INT,
	@email VARCHAR(255) = NULL,
	@phone VARCHAR(20) = NULL,
	@address TEXT = NULL
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM suppliers
	WHERE id = @supplier_id AND user_id = @user_id
    )
    BEGIN
		UPDATE suppliers
        SET name = @name, address = @address, email = @email, phone = @phone
        WHERE id = @supplier_id AND user_id = @user_id;

		SELECT 1 AS success, 'Supplier updated successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Update failed: Supplier not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Delete Supplier
CREATE PROCEDURE deleteSupplier
	@supplier_id INT,
	@user_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM suppliers
	WHERE id = @supplier_id AND user_id = @user_id
    )
    BEGIN
		DELETE FROM suppliers
        WHERE id = @supplier_id AND user_id = @user_id;

		SELECT 1 AS success, 'Supplier deleted successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Deletion failed: Supplier not found or access denied.' AS message;
	END
END;
GO