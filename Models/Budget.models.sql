use Project

CREATE TABLE budget (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    department_id INT NOT NULL,
    allocated_amount DECIMAL(15,2) NOT NULL,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (department_id) REFERENCES departments(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);




-- Procedure to Create Budget
CREATE PROCEDURE createBudget
    @department_id INT,
    @allocated_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO budget (department_id, allocated_amount)
    VALUES (@department_id, @allocated_amount);
END


CREATE PROCEDURE updateBudget
	@budget_id int,
	@user_id int,
    @department_id INT,
    @allocated_amount DECIMAL(15,2)

AS
BEGIN
	if exists(
		select 1 from budget
		where id=@budget_id and user_id=@user_id and department_id=@department_id
	)
	begin
		update budgets
		set allocated_amount = @allocated_amount
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END



CREATE PROCEDURE deleteBudget
	@budget_id int,
	@user_id int,
    @department_id INT,
   

AS
BEGIN
	if exists(
		select 1 from budget
		where id=@budget_id and user_id=@user_id and department_id=@department_id
	)
	begin
		delete from budgets 
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END



CREATE PROCEDURE getBudgets
	
	@user_id int,
    @department_id INT,
  

AS
BEGIN
	if exists(
		select 1 from budget
		where user_id=@user_id and department_id=@department_id
	)
	begin
		select 1 as success,* from budgets
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END

