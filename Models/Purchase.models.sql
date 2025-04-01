
USE Project;

create table purchases
(
    id int primary key identity(1,1),
    user_id int not null,
    supplier_id int not null,
    total_amount decimal(15,2) not null,
    purchase_date DATETIME default GETDATE(),
    foreign key (supplier_id) references suppliers(id) on delete cascade on update cascade,
    foreign key (user_id) references users(id) on delete cascade on update cascade
)
GO
-- Procedure to Create a Purchase
CREATE PROCEDURE createPurchase
    @user_id INT,
    @supplier_id INT,
    @total_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO purchases
        (user_id, supplier_id, total_amount)
    VALUES
        (@user_id, @supplier_id, @total_amount);

    SELECT 1 AS success, 'Purchase created successfully.' AS message;
END;
GO
-- Procedure to Get Purchases by User
CREATE PROCEDURE getPurchasesByUser
    @user_id INT
AS
BEGIN
    SELECT *
    FROM purchases
    WHERE user_id = @user_id;
END;
GO
-- Procedure to Update Purchase Details
CREATE PROCEDURE updatePurchase
    @purchase_id INT,
    @user_id INT,
    @supplier_id INT,
    @total_amount DECIMAL(15,2)
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM purchases
    WHERE id = @purchase_id AND user_id = @user_id
    )
    BEGIN
        UPDATE purchases
        SET supplier_id = @supplier_id, total_amount = @total_amount, purchase_date = GETDATE()
        WHERE id = @purchase_id AND user_id = @user_id;

        SELECT 1 AS success, 'Purchase updated successfully.' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Purchase not found or access denied.' AS message;
    END
END;
GO
-- Procedure to Delete a Purchase
CREATE PROCEDURE deletePurchase
    @purchase_id INT,
    @user_id INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM purchases
    WHERE id = @purchase_id AND user_id = @user_id
    )
    BEGIN
        DELETE FROM purchases
        WHERE id = @purchase_id AND user_id = @user_id;

        SELECT 1 AS success, 'Purchase deleted successfully.' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Purchase not found or access denied.' AS message;
    END
END;
GO
-- Procedure to Get a Specific Purchase
CREATE PROCEDURE getPurchase
    @purchase_id INT,
    @user_id INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM purchases
    WHERE id = @purchase_id AND user_id = @user_id
    )
    BEGIN
        SELECT *
        FROM purchases
        WHERE id = @purchase_id AND user_id = @user_id;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Purchase not found or access denied.' AS message;
    END
END;
GO