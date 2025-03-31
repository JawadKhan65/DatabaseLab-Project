use Project

-- 13. Sale Details (Items in a Sale)
CREATE TABLE sale_details (
    id INT PRIMARY KEY IDENTITY(1,1),
	user_id int not null,
    sale_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,

    FOREIGN KEY (inventory_id) REFERENCES inventory(id) on delete cascade on update cascade,
	foreign key (user_id) references users(id) on delete cascade on update cascade
);


