USE Project;

create table inventory_permissions
(
    id int primary key identity(1,1),
    user_id int not null,
    inventory_id int not null,
    permission_type varchar(50) not null check (permission_type in ('readPrimary','writePrimary','readSecondary','writeSecondary')),
    foreign key (user_id) references users(id) on delete NO ACTION on update NO ACTION,
    foreign key (inventory_id) references inventory(id) on delete CASCADE on update CASCADE
)
GO

-- Procedure: grantAccess
CREATE PROCEDURE grantAccess
    @inventory_id INT,
    @user_id_giver INT,
    @user_id_grant INT,
    @permission_type VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1
        FROM inventory
        WHERE id = @inventory_id AND user_id = @user_id_giver)
        AND EXISTS (SELECT 1
        FROM users
        WHERE id = @user_id_grant)
    BEGIN
        -- Check if permission already exists
        IF NOT EXISTS (SELECT 1
        FROM inventory_permissions
        WHERE user_id = @user_id_grant AND inventory_id = @inventory_id)
        BEGIN
            INSERT INTO inventory_permissions
                (user_id, inventory_id, permission_type)
            VALUES
                (@user_id_grant, @inventory_id, @permission_type);
            SELECT 1 AS success, 'Access Granted' AS message;
        END
        ELSE
        BEGIN
            SELECT 0 AS success, 'User already has permissions for this inventory' AS message;
        END
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Grant Access Denied - Either inventory doesn''t belong to giver or user doesn''t exist' AS message;
    END
END;
GO
-- Procedure: checkAccess
CREATE PROCEDURE checkAccess
    @user_id_grant INT,
    @inventory_id INT
AS
BEGIN
    IF EXISTS (SELECT 1
    FROM inventory_permissions
    WHERE user_id = @user_id_grant AND inventory_id = @inventory_id)
    BEGIN
        SELECT inventory_id
        FROM inventory_permissions
        WHERE user_id = @user_id_grant;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'No Access Found' AS message;
    END
END;
GO
-- Procedure: deleteAccess
CREATE PROCEDURE deleteAccess
    @user_id_grant INT,
    @inventory_id INT
AS
BEGIN
    IF EXISTS (SELECT 1
    FROM inventory_permissions
    WHERE user_id = @user_id_grant AND inventory_id = @inventory_id)
    BEGIN
        DELETE FROM inventory_permissions WHERE user_id = @user_id_grant AND inventory_id = @inventory_id;
        SELECT 1 AS success, 'Access Deleted Successfully' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Access Not Found' AS message;
    END
END;
GO
-- Procedure: updateAccess
CREATE PROCEDURE updateAccess
    @user_id_grant INT,
    @inventory_id INT,
    @permission_type VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1
    FROM inventory_permissions
    WHERE user_id = @user_id_grant AND inventory_id = @inventory_id)
    BEGIN
        UPDATE inventory_permissions
        SET permission_type = @permission_type
        WHERE user_id = @user_id_grant AND inventory_id = @inventory_id;
        SELECT 1 AS success, 'Permission Updated Successfully' AS message;
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Access Not Found' AS message;
    END
END;
GO