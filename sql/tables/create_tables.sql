-- Create Player table
CREATE TABLE Player (
	player_id SERIAL PRIMARY KEY,
	employee_id SERIAL REFERENCES Employee(employee_id),
	game_id SERIAL REFERENCES Game(game_id)
	name VARCHAR(255) NOT NULL,
	date_of_birth DATE,
	email VARCHAR(255) UNIQUE,
	address TEXT
	username VARCHAR(50) UNIQUE
);

-- Create Account table
CREATE TABLE Account (
	account_id SERIAL PRIMARY KEY,
	player_id SERIAL REFERENCES Player(player_id)
	balance DECIMAL(10, 2) DEFAULT 0.0,
	status VARCHAR(20) DEFAULT 'Active'
);

-- Create Transaction table
CREATE TABLE Transaction (
	transaction_id SERIAL PRIMARY KEY,
	account_id SERIAL REFERENCES Account(account_id),
	manager_id SERIAL REFERENCES Manager(manager_id),
	game_id SERIAL REFERENCES Game(game_id),
	amount DECIMAL(10, 2),
	status VARCHAR(20),
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Game table
CREATE TABLE Game (
	game_id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	rating VARCHAR(10),
	genre VARCHAR(50)
	publisher VARCHAR(255),
	release_date DATE
);
