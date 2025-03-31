use Project

CREATE TABLE purchases (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    supplier_id INT NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    purchase_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);


