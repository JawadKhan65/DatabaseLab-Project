
use Project

CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL CHECK (phone LIKE '+%-%-%'), -- E.g., +1-555-123-4567
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'employee', 'manager')),
    created_at DATETIME DEFAULT GETDATE()
);






create procedure createUser 
	@firstName VARCHAR(255),
	@lastName VARCHAR(255),
	@email VARCHAR(255),
	@phone VARCHAR(15),
	@password VARCHAR(255),
	@role VARCHAR(20)
as
begin
	IF NOT EXISTS (SELECT 1 FROM users WHERE email = @email)
	begin
    INSERT INTO users (firstName, lastName, email, phone, password_hash, role)
    VALUES (@firstName, @lastName, @email, @phone, @password, @role);
	select 1 as success ,'user created' as data 
	end
	else
	begin
	select 0 as success, 'Failed to create user' as message
	end
	

end



exec createUser @firstName='jk', @lastName='lk',@email='jk@email.com',@phone='+92-302-4310826',@password='123',@role='admin'




create procedure deleteUser 
	@email varchar(255)
as
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin
		delete from users
		where email=@email
		select 1 as success,'deletion succcessfull' as message
	end
	else
	begin
	select 0 as success, 'Failed to create user' as message
	end
end

exec deleteUser @email = 'jk@email.com'



create procedure updatePassword
	@email varchar(255),
	@password varchar(255)

as
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin

		update users
		set password_hash=@password
		where email=@email
		select 1 as success, 'updated password' as message
	end
	else
	begin
		select 0 as success,'couldnt update password' as message
	end
	
end

exec updatePassword @email='jk@email.com' , @password='456'

create procedure getUserId
	@email varchar(255)

as 
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin 
		select 1 as success, id from users
		where email=@email

	end
	else
	begin
	select 0 as success,'couldnt fettch userID' as message
	end

end


exec getUserId @email='jk@email.com'


select * from users


create procedure login
	@email varchar(255)

as 
begin
	if exists(
		select 1 from users
		where email=@email
	)
	begin

		select 1 as success,firstName,lastName,email,phone,role,password_hash from users
		where email=@email
	end
	else
	begin
		select 0 as  success, 'No such user' as message
	end
end


create procedure getUserDetails
	@email varchar(255)

as 
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin 
		select 1 as success, * from users
		where email=@email

	end
	else
	begin
	select 0 as success,'couldnt fettch userDetails' as message
	end

end
