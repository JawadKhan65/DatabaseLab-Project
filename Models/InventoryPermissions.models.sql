use Project


CREATE TABLE inventory_permissions (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    inventory_id INT NOT NULL,
    permission_type VARCHAR(50) not null check (permission_type in ('readPrimary','writePrimary','readSecondary','writeSecondary'))
    FOREIGN KEY (inventory_id) REFERENCES inventory(id) on delete cascade on update cascade
);




--procedures for Access Managment
 
CREATE PROCEDURE grantAccess
    @inventory_id INT,
    @user_id_giver INT,
    @user_id_grant INT,
    @permission_type VARCHAR(50)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inventory 
        WHERE id = @inventory_id AND user_id = @user_id_giver
    )
    AND EXISTS (
        SELECT 1 FROM users 
        WHERE id = @user_id_grant
    )
    BEGIN
        -- Check if permission already exists
        IF NOT EXISTS (
            SELECT 1 FROM inventory_permissions 
            WHERE user_id = @user_id_grant 
            AND inventory_id = @inventory_id
        )
        BEGIN
            INSERT INTO inventory_permissions(user_id, inventory_id, permission_type)
            VALUES (@user_id_grant, @inventory_id, @permission_type);
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
END



create procedure checkAccess
	@user_id_grant int,
	@inventory_id int
as
begin
	select distinct inventory_id from inventory_permissions
	where user_id=@user_id_grant
end

create procedure deleteAccess
	@user_id_grant int,
	@inventory_id int
as
begin
	delete from inventory_permissions
	where user_id = @user_id_grant and inventory_id=@inventory_id

end

create procedure updateAccess
	@user_id_grant int,
	@inventory_id int,
	@permission_type

as 
begin
	update inventory_permissions
	set permission_type=@permission_type
	where user_id = @user_id_grant and inventory_id=@inventory_id

end
