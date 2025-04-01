USE Project;

create table budget
(
	id int primary key identity(1,1),
	user_id int not null,
	department_id int not null,
	allocated_amount decimal(15,2) not null,
	spent_amount decimal(15,2) default 0,
	created_at DATETIME default GETDATE(),
	foreign key (department_id) references departments(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO

-- Procedure to Create Budget
CREATE PROCEDURE createBudget
	@department_id INT,
	@allocated_amount DECIMAL(15,2)
AS
BEGIN
	INSERT INTO budget
		(department_id, allocated_amount)
	VALUES
		(@department_id, @allocated_amount);

	SELECT 1 AS success, 'Budget created successfully.' AS message;
END;
GO
-- Procedure to Update Budget
CREATE PROCEDURE updateBudget
	@budget_id INT,
	@user_id INT,
	@department_id INT,
	@allocated_amount DECIMAL(15,2)
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM budget
	WHERE id = @budget_id AND user_id = @user_id AND department_id = @department_id
    )
    BEGIN
		UPDATE budget
        SET allocated_amount = @allocated_amount
        WHERE id = @budget_id AND user_id = @user_id AND department_id = @department_id;

		SELECT 1 AS success, 'Budget updated successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Budget not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Delete Budget
CREATE PROCEDURE deleteBudget
	@budget_id INT,
	@user_id INT,
	@department_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM budget
	WHERE id = @budget_id AND user_id = @user_id AND department_id = @department_id
    )
    BEGIN
		DELETE FROM budget
        WHERE id = @budget_id AND user_id = @user_id AND department_id = @department_id;

		SELECT 1 AS success, 'Budget deleted successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Budget not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Get Budgets
CREATE PROCEDURE getBudgets
	@user_id INT,
	@department_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM budget
	WHERE user_id = @user_id AND department_id = @department_id
    )
    BEGIN
		SELECT 1 AS success, *
		FROM budget
		WHERE user_id = @user_id AND department_id = @department_id;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'No budgets found for the specified department.' AS message;
	END
END;
GO