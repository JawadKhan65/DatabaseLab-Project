use Project
CREATE TABLE expenses (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    category VARCHAR(255) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    department_id INT NOT NULL,
    date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (department_id) REFERENCES departments(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);




-- Procedure to Create Expense
CREATE PROCEDURE createExpense
    @category VARCHAR(255),
    @amount DECIMAL(15,2),
    @description TEXT = NULL,
    @department_id INT
AS
BEGIN
    INSERT INTO expenses (category, amount, description, department_id)
    VALUES (@category, @amount, @description, @department_id);
END

create procedure updateExpense
	@expense_id int,
	@user_id int,
	@category varchar(255),
	@amount varchar(255),
	@description varchar(255),
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		update expenses
		set category=@category, amount=@amount,description=@description
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		select 1 as success, 'Updation Succesfull' as message
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end



create procedure deleteExpense
	@expense_id int,
	@user_id int,
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		delete from expenses
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		select 1 as success, 'Updation Succesfull' as message
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end


create procedure getExpenses
	@expense_id int,
	@user_id int,
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		select 1 as success, * from expenses
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end