USE Project;

create table sale_details
(
    id int primary key identity(1,1),
    user_id int not null,
    sale_id int not null,
    inventory_id int not null,
    quantity int not null,
    price DECIMAL(10,2) not null,
    foreign key (sale_id) references sales(id) on delete NO ACTION on update NO ACTION,
    foreign key (inventory_id) references inventory(id) on delete NO ACTION on update NO ACTION,
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION
)
GO
-- Procedure to Create Sale Detail
CREATE PROCEDURE createSaleDetail
    @user_id INT,
    @sale_id INT,
    @inventory_id INT,
    @quantity INT,
    @price DECIMAL(10,2)
AS
BEGIN
    INSERT INTO sale_details
        (user_id, sale_id, inventory_id, quantity, price)
    VALUES
        (@user_id, @sale_id, @inventory_id, @quantity, @price);

    SELECT 1 AS success, 'Sale detail added successfully.' AS message;
END;
GO
-- Procedure to Get Sale Details by Sale ID
CREATE PROCEDURE getSaleDetailsBySaleId
    @sale_id INT
AS
BEGIN
    SELECT *
    FROM sale_details
    WHERE sale_id = @sale_id;
END;
GO
-- Procedure to Update Sale Detail
CREATE PROCEDURE updateSaleDetail
    @sale_detail_id INT,
    @user_id INT,
    @quantity INT,
    @price DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM sale_details
    WHERE id = @sale_detail_id AND user_id = @user_id
    )
    BEGIN
        UPDATE sale_details
        SET quantity = @quantity, price = @price
        WHERE id = @sale_detail_id AND user_id = @user_id;

        SELECT 1 AS success, 'Sale detail updated successfully.' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Sale detail not found or access denied.' AS message;
    END
END;
GO
-- Procedure to Delete Sale Detail
CREATE PROCEDURE deleteSaleDetail
    @sale_detail_id INT,
    @user_id INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
    FROM sale_details
    WHERE id = @sale_detail_id AND user_id = @user_id
    )
    BEGIN
        DELETE FROM sale_details
        WHERE id = @sale_detail_id AND user_id = @user_id;

        SELECT 1 AS success, 'Sale detail deleted successfully.' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Sale detail not found or access denied.' AS message;
    END
END;
GO