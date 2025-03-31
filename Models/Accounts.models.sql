use Project

CREATE TABLE accounts (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    account_name VARCHAR(255) NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    last_transaction_date DATETIME DEFAULT GETDATE(),
	foreign key (user_id) references users(id) on delete cascade on update cascade
);



-- Procedure to Create Account
CREATE PROCEDURE createAccount
    @account_name VARCHAR(255),
    @balance DECIMAL(15,2),
    @user_id INT
AS
BEGIN
    INSERT INTO accounts (account_name, balance, userid)
    VALUES (@account_name, @balance, @user_id);
END


create procedure getAccounts
	@user_id int
AS 
BEGIN
	SELECT * FROM accounts
	where user_id=@user_id
END

create deleteAccount
	@user_id int,
	@account_id int,

as
begin
	delete from accounts 
	where user_id = @user_id and id=@account_id

end


create procedure updateAccount
	@user_id int,
	@account_id int,
	@balance decimal(15,2),
	@account_name varchar(255)
	
as
begin
	update accounts
	set balance=@balance, account_name=@account_name, last_transaction_date= GETDATE()
	where user_id=@user_id and id=@account_id
end
