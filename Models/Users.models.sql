USE Project;

create table users
(
	id int primary key identity(1,1),
	firstName varchar(255) not null,
	lastName varchar(255) not null,
	email varchar(255) unique not null,
	phone varchar(15) not null check (phone LIKE '+%-%-%'),
	password_hash varchar(255) not null,
	role varchar(20) not null check (role IN ('admin', 'employee', 'manager')),
	created_at DATETIME default GETDATE()
)
GO


-- Procedure to Create User with Additional Validations
CREATE PROCEDURE createUser
	@firstName VARCHAR(255),
	@lastName VARCHAR(255),
	@email VARCHAR(255),
	@phone VARCHAR(15),
	@password VARCHAR(255),
	@role VARCHAR(20)
AS
BEGIN
	-- Check if email already exists
	IF EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'Email already exists' AS message;
		RETURN;
	END

	-- Check if role is valid
	IF @role NOT IN ('admin', 'employee', 'manager')
    BEGIN
		SELECT 0 AS success, 'Invalid role' AS message;
		RETURN;
	END

	-- Check phone number format
	IF @phone NOT LIKE '+%-%-%'
    BEGIN
		SELECT 0 AS success, 'Invalid phone format' AS message;
		RETURN;
	END

	INSERT INTO users
		(firstName, lastName, email, phone, password_hash, role)
	VALUES
		(@firstName, @lastName, @email, @phone, @password, @role);

	SELECT 1 AS success, 'User created successfully' AS message;
END
GO

-- Procedure to Delete User with Validation
CREATE PROCEDURE deleteUser
	@email VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'User does not exist' AS message;
		RETURN;
	END

	DELETE FROM users WHERE email = @email;
	SELECT 1 AS success, 'User deleted successfully' AS message;
END
GO

-- Procedure to Update User Password with Validation
CREATE PROCEDURE updatePassword
	@email VARCHAR(255),
	@password VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'User not found' AS message;
		RETURN;
	END

	UPDATE users SET password_hash = @password WHERE email = @email;
	SELECT 1 AS success, 'Password updated successfully' AS message;
END
GO
-- Procedure to Retrieve User ID
CREATE PROCEDURE getUserId
	@email VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'User not found' AS message;
		RETURN;
	END

	SELECT 1 AS success, id
	FROM users
	WHERE email = @email;
END
GO

-- Procedure to Login
CREATE PROCEDURE login
	@email VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'No such user' AS message;
		RETURN;
	END

	SELECT 1 AS success, firstName, lastName, email, phone, role, password_hash
	FROM users
	WHERE email = @email;
END
GO

-- Procedure to Get User Details
CREATE PROCEDURE getUserDetails
	@email VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS (SELECT 1
	FROM users
	WHERE email = @email)
    BEGIN
		SELECT 0 AS success, 'User not found' AS message;
		RETURN;
	END

	SELECT 1 AS success, *
	FROM users
	WHERE email = @email;
END

GO
