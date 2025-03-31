use Project


CREATE TABLE departments (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    name VARCHAR(255) UNIQUE NOT NULL,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);




---- department procedures

create procedure createDepartment
	@user_id int,
	@department_name varchar(255)
as
begin
	insert into departments(name,user_id)
	values
	(@department_name,@user_id)
end


create procedure getDepartments
	@user_id int,
	@department_id int
	

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	select  1 as success, * from departments
	where id =@department_id and user_id=@user_id

	
	end
	else
	begin
		select 0 as success , 'updation failed' as message
	end

end




create procedure updateDepartment
	@user_id int,
	@department_id int,
	@name varchar(255)

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	update departments
	set name=@name
	where id =@department_id and user_id=@user_id

	select 1 as success, 'updated successfully' as message
	end
	else
	begin
		select 0 as success , 'updation failed' as message
	end

end


create procedure deleteDepartment
	@user_id int,
	@department_id int

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	delete from  departments
	where id =@department_id and user_id=@user_id
	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end

end

