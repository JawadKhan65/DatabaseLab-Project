USE Project;

create table expenses
(
	id int primary key identity(1,1),
	user_id int not null,
	category varchar(255) not null,
	amount decimal(15,2) not null,
	description varchar(max),
	department_id int not null,
	date DATETIME default GETDATE(),
	foreign key (department_id) references departments(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO

-- Procedure: Create Expense
CREATE PROCEDURE createExpense
	@user_id INT,
	@category VARCHAR(255),
	@amount DECIMAL(15,2),
	@description TEXT = NULL,
	@department_id INT
AS
BEGIN
	INSERT INTO expenses
		(user_id, category, amount, description, department_id)
	VALUES
		(@user_id, @category, @amount, @description, @department_id);

	-- Return the ID of the newly created expense
	SELECT SCOPE_IDENTITY() AS expense_id;
END;
GO
-- Procedure: Update Expense
CREATE PROCEDURE updateExpense
	@expense_id INT,
	@user_id INT,
	@category VARCHAR(255),
	@amount DECIMAL(15,2),
	@description TEXT,
	@department_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM expenses
	WHERE id = @expense_id AND user_id = @user_id AND department_id = @department_id
    )
    BEGIN
		UPDATE expenses
        SET category = @category, amount = @amount, description = @description, date = GETDATE()
        WHERE id = @expense_id AND user_id = @user_id AND department_id = @department_id;

		SELECT 1 AS success, 'Update Successful' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Expense Not Found or Permission Denied' AS message;
	END
END;
GO
-- Procedure: Delete Expense
CREATE PROCEDURE deleteExpense
	@expense_id INT,
	@user_id INT,
	@department_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM expenses
	WHERE id = @expense_id AND user_id = @user_id AND department_id = @department_id
    )
    BEGIN
		DELETE FROM expenses
        WHERE id = @expense_id AND user_id = @user_id AND department_id = @department_id;

		SELECT 1 AS success, 'Deletion Successful' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Expense Not Found or Permission Denied' AS message;
	END
END;
GO
-- Procedure: Get Expense

CREATE PROCEDURE getExpenses

	@user_id INT

AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM expenses
	WHERE  user_id = @user_id 
	)
    BEGIN
		SELECT *
		FROM expenses
		WHERE user_id = @user_id
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Expense Not Found' AS message;
	END
END;
GO