use Project

CREATE TABLE dispatch (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    order_id INT NOT NULL,
    dispatch_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'dispatched', 'delivered')),
    FOREIGN KEY (order_id) REFERENCES orders(id),
	foreign key (user_id) references users(id) on delete cascade on update cascade
);





-- Procedure to Create Dispatch
CREATE PROCEDURE createDispatch
    @order_id INT,
	@user_id int,
	
AS
BEGIN
    INSERT INTO dispatch (order_id, user_id)
    VALUES (@order_id, @user_id);
END


create procedure updateDispatch
	@dispatch_id int,
	@user_id int,
	@status
as 
begin
	update dispatch
	set status=@status
	where user_id=@user_id and id=@dispatch_id

end


create procedure deleteDispatch
	@dispatch_id int,
	@user_id int,
as
begin
	delete from dispatch
	where id=@dispatch_id and user_id = @user_id
end

create procedure getDispatch
	@order_id int,
	@user_id  int

as 
begin
	select * from dispatch
	where order_id=@order_id and user_id=@user_id
end

