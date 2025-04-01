USE Project;

create table dispatch
(

	id int primary key identity(1,1),
	user_id int not null,
	order_id int not null,
	dispatch_date DATETIME default GETDATE(),
	status VARCHAR(50) default 'pending' CHECK (status IN ('pending', 'dispatched', 'delivered')),
	foreign key (order_id) references orders(id),
	foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO


-- Procedure to Create Dispatch
CREATE PROCEDURE createDispatch
	@order_id INT,
	@user_id INT

AS
BEGIN
	INSERT INTO dispatch
		(order_id, user_id)
	VALUES
		(@order_id, @user_id);
END;
GO

-- Procedure to Update Dispatch Status
CREATE PROCEDURE updateDispatch
	@dispatch_id INT,
	@user_id INT,
	@status VARCHAR(50)
AS
BEGIN
	UPDATE dispatch
    SET status = @status
    WHERE user_id = @user_id AND id = @dispatch_id;
END;
GO
-- Procedure to Delete Dispatch
CREATE PROCEDURE deleteDispatch
	@dispatch_id INT,
	@user_id INT
AS
BEGIN
	IF EXISTS (
        SELECT 1
	FROM dispatch
	WHERE id = @dispatch_id AND user_id = @user_id
    )
    BEGIN
		DELETE FROM dispatch
        WHERE id = @dispatch_id AND user_id = @user_id;

		SELECT 1 AS success, 'Dispatch Deleted Successfully' AS message;
	END
    ELSE
    BEGIN
		SELECT 0 AS success, 'Dispatch Not Found' AS message;
	END
END;
GO
-- Procedure to Get Dispatch Details
CREATE PROCEDURE getDispatch
	@order_id INT,
	@user_id INT
AS
BEGIN
	SELECT *
	FROM dispatch
	WHERE order_id = @order_id AND user_id = @user_id;
END;
GO