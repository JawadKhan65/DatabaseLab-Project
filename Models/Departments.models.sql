USE Project;

create table departments
(
	id int primary key identity(1,1),
	user_id int not null,
	name varchar(255) unique not null,
	foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO

-- Procedure to Create Department
CREATE PROCEDURE createDepartment
	@user_id INT,
	@department_name VARCHAR(255)
AS
BEGIN
	-- Check if department name already exists
	IF EXISTS (SELECT 1
	FROM departments
	WHERE name = @department_name)
    BEGIN
		SELECT 0 AS success, 'Department name already exists.' AS message;
	END
    ELSE
    BEGIN
		INSERT INTO departments
			(name, user_id)
		VALUES
			(@department_name, @user_id);

		SELECT 1 AS success, 'Department created successfully.' AS message;
	END
END;
GO
-- Procedure to Get Department(s)

CREATE PROCEDURE getDepartments
	@user_id INT

AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM departments
	WHERE  user_id = @user_id
    )
    BEGIN
		SELECT 1 AS success, *
		FROM departments
		WHERE  user_id = @user_id;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Department not found.' AS message;
	END
END;
GO
-- Procedure to Update Department
CREATE PROCEDURE updateDepartment
	@user_id INT,
	@department_id INT,
	@name VARCHAR(255)
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM departments
	WHERE id = @department_id AND user_id = @user_id
    )
    BEGIN
		UPDATE departments
        SET name = @name
        WHERE id = @department_id AND user_id = @user_id;

		SELECT 1 AS success, 'Department updated successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Department not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Delete Department
CREATE PROCEDURE deleteDepartment
	@user_id INT,
	@department_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM departments
	WHERE id = @department_id AND user_id = @user_id
    )
    BEGIN
		DELETE FROM departments
        WHERE id = @department_id AND user_id = @user_id;

		SELECT 1 AS success, 'Department deleted successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Department not found or access denied.' AS message;
	END
END;
GO