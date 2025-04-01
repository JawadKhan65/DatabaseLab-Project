USE Project;

create table accounts
(
	id int primary key IDENTITY(1,1),
	user_id int not null,
	account_name varchar(255) not null,
	balance decimal(15,2) not null,
	last_transaction_date DATETIME default GETDATE(),
	foreign key (user_id) references users(id) ON delete cascade on update cascade
)
GO

-- Procedure to Create Account
CREATE PROCEDURE createAccount
	@account_name VARCHAR(255),
	@balance DECIMAL(15,2),
	@user_id INT
AS
BEGIN
	INSERT INTO accounts
		(account_name, balance, user_id)
	VALUES
		(@account_name, @balance, @user_id);

	SELECT 1 AS success, 'Account created successfully.' AS message;
END;
GO
-- Procedure to Get Accounts
CREATE PROCEDURE getAccounts
	@user_id INT
AS
BEGIN
	SELECT *
	FROM accounts
	WHERE user_id = @user_id;
END;
GO
-- Procedure to Delete Account
CREATE PROCEDURE deleteAccount
	@user_id INT,
	@account_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM accounts
	WHERE user_id = @user_id AND id = @account_id
    )
    BEGIN
		DELETE FROM accounts 
        WHERE user_id = @user_id AND id = @account_id;

		SELECT 1 AS success, 'Account deleted successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Account not found or access denied.' AS message;
	END
END;
GO
-- Procedure to Update Account
CREATE PROCEDURE updateAccount
	@user_id INT,
	@account_id INT,
	@balance DECIMAL(15,2),
	@account_name VARCHAR(255)
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM accounts
	WHERE user_id = @user_id AND id = @account_id
    )
    BEGIN
		UPDATE accounts
        SET balance = @balance, account_name = @account_name, last_transaction_date = GETDATE()
        WHERE user_id = @user_id AND id = @account_id;

		SELECT 1 AS success, 'Account updated successfully.' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Account not found or access denied.' AS message;
	END
END;
GO