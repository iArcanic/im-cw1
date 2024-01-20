-- Create tables

-- Create Game table
CREATE TABLE Game (
    game_id SERIAL PRIMARY KEY, title VARCHAR(255) NOT NULL, rating VARCHAR(10), genre VARCHAR(50), publisher VARCHAR(255), release_date DATE
);

-- Create Employee table
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY, game_id SERIAL REFERENCES Game (game_id), name VARCHAR(255) NOT NULL, date_of_birth DATE, address TEXT, job_title VARCHAR(255)
);

-- Create Player table
CREATE TABLE Player (
    player_id SERIAL PRIMARY KEY, employee_id SERIAL REFERENCES Employee (employee_id), game_id SERIAL REFERENCES Game (game_id), name VARCHAR(255) NOT NULL, date_of_birth DATE, email VARCHAR(255) UNIQUE, address TEXT, username VARCHAR(50) UNIQUE
);

-- Create Manager table
CREATE TABLE Manager (
    manager_id SERIAL PRIMARY KEY, employee_id SERIAL REFERENCES Employee (employee_id), name VARCHAR(255) NOT NULL, date_of_birth DATE, address TEXT
);

-- Create Tournament table
CREATE TABLE Tournament (
    tournament_id SERIAL PRIMARY KEY, game_id SERIAL REFERENCES Game (game_id), start_timestamp TIMESTAMP, end_timestamp TIMESTAMP, prize VARCHAR(255)
);

-- Create PlayerGame table
CREATE TABLE PlayerGame (
    player_id SERIAL REFERENCES Player (player_id), game_id SERIAL REFERENCES Game (game_id), PRIMARY KEY (player_id, game_id)
);

-- Create EmployeeGame table
CREATE TABLE EmployeeGame (
    employee_id SERIAL REFERENCES Employee (employee_id), game_id SERIAL REFERENCES Game (game_id), PRIMARY KEY (employee_id, game_id)
);

-- Create Transaction table
CREATE TABLE Transaction (
    transaction_id SERIAL PRIMARY KEY, account_id SERIAL REFERENCES Account (account_id), manager_id SERIAL REFERENCES Manager (manager_id), game_id SERIAL REFERENCES Game (game_id), amount DECIMAL(10, 2), status VARCHAR(20), timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create TransactionGame table
CREATE TABLE TransactionGame (
    transaction_id SERIAL REFERENCES Transaction (transaction_id), game_id SERIAL REFERENCES Game (game_id), PRIMARY KEY (transaction_id, game_id)
);

-- Create Account table
CREATE TABLE Account (
    account_id SERIAL PRIMARY KEY, player_id SERIAL REFERENCES Player (player_id), balance DECIMAL(10, 2) DEFAULT 0.0, status VARCHAR(20) DEFAULT 'Active'
);
--
-- -- Create relationships
--
-- -- EmployeeGame (Many-to-Many between Employee and Game)
-- ALTER TABLE EmployeeGame
-- ADD CONSTRAINT fk_employeegame_employee FOREIGN KEY (employee_id) REFERENCES Employee (employee_id);
--
-- ALTER TABLE EmployeeGame
-- ADD CONSTRAINT fk_employeegame_game FOREIGN KEY (game_id) REFERENCES Game (game_id);
--
-- -- PlayerGame (Many-to-Many between Player and Game)
-- ALTER TABLE PlayerGame
-- ADD CONSTRAINT fk_playergame_player FOREIGN KEY (player_id) REFERENCES Player (player_id);
--
-- ALTER TABLE PlayerGame
-- ADD CONSTRAINT fk_playergame_game FOREIGN KEY (game_id) REFERENCES Game (game_id);
--
-- -- TransactionGame (Many-to-Many between Transaction and Game)
-- ALTER TABLE TransactionGame
-- ADD CONSTRAINT fk_transactiongame_transaction FOREIGN KEY (transaction_id) REFERENCES Transaction (transaction_id);
--
-- ALTER TABLE TransactionGame
-- ADD CONSTRAINT fk_transactiongame_game FOREIGN KEY (game_id) REFERENCES Game (game_id);
--
-- -- Employee to Manager (One-to-One)
-- ALTER TABLE Manager
-- ADD CONSTRAINT fk_manager_employee FOREIGN KEY (employee_id) REFERENCES Employee (employee_id);
--
-- -- Player to Employee (Many-to-One)
-- ALTER TABLE Player
-- ADD CONSTRAINT fk_player_employee FOREIGN KEY (employee_id) REFERENCES Employee (employee_id);
--
-- -- Account to Player (Many-to-One)
-- ALTER TABLE Account
-- ADD CONSTRAINT fk_account_player FOREIGN KEY (player_id) REFERENCES Player (player_id);
--
-- -- Transaction to Account (Many-to-One)
-- ALTER TABLE Transaction
-- ADD CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES Account (account_id);
--
-- -- Transaction to Manager (Many-to-One)
-- ALTER TABLE Transaction
-- ADD CONSTRAINT fk_transaction_manager FOREIGN KEY (manager_id) REFERENCES Manager (manager_id);
--
-- -- Game to Tournament (One-to-Many)
-- ALTER TABLE Tournament
-- ADD CONSTRAINT fk_tournament_game FOREIGN KEY (game_id) REFERENCES Game (game_id);
--
-- -- Create roles and schema
-- CREATE ROLE admin;
--
-- CREATE ROLE manager;
--
-- CREATE ROLE player;
--
-- CREATE ROLE employee;
--
-- -- Assign permissions to roles
-- GRANT ALL PRIVILEGES ON SCHEMA public TO admin;
--
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
--
-- GRANT SELECT, INSERT , UPDATE, DELETE ON TABLE Employee TO manager;
--
-- GRANT
-- SELECT (
--         manager_id, employee_id, name, date_of_birth, address
--     ) ON
-- TABLE Manager TO manager;
--
-- GRANT
-- UPDATE (
--     employee_id, name, date_of_birth, address
-- ) ON
-- TABLE Manager TO manager;
--
-- GRANT
-- SELECT,
-- INSERT
-- ,
-- UPDATE,
-- DELETE ON
-- TABLE Transaction TO manager;
--
-- GRANT SELECT, INSERT , UPDATE, DELETE ON TABLE Player TO manager;
--
-- GRANT
-- SELECT (
--         player_id, name, date_of_birth, email, address, username
--     ) ON
-- TABLE Player TO player;
--
-- GRANT
-- UPDATE (
--     name, date_of_birth, email, address, username
-- ) ON
-- TABLE Player TO player;
--
-- GRANT SELECT (player_id, status) ON TABLE Account TO player;
--
-- GRANT SELECT, INSERT , UPDATE, DELETE ON TABLE Player TO employee;
--
-- GRANT SELECT, INSERT , UPDATE, DELETE ON TABLE Game TO employee;
--
-- -- Create schemas
-- CREATE SCHEMA game_schema AUTHORIZATION manager;
--
-- CREATE SCHEMA player_schema AUTHORIZATION player;
--
-- CREATE SCHEMA employee_schema AUTHORIZATION employee;
--
-- -- Object ownership
-- ALTER TABLE game_schema.Game OWNER TO manager;
--
-- ALTER TABLE player_schema.Player OWNER TO player;
--
-- ALTER TABLE employee_schema.Employee OWNER TO employee;
--
-- -- Default privileges
-- ALTER DEFAULT PRIVILEGES IN SCHEMA game_schema
-- GRANT
-- SELECT,
-- INSERT
-- ,
-- UPDATE,
-- DELETE ON TABLES TO manager;
--
-- ALTER DEFAULT PRIVILEGES IN SCHEMA player_schema
-- GRANT
-- SELECT,
-- INSERT
-- ,
-- UPDATE,
-- DELETE ON TABLES TO player;
--
-- -- Create views
--
-- -- Admin dashboard view
-- CREATE OR REPLACE VIEW admin_overview AS
-- SELECT
--     p.player_id,
--     p.name AS player_name,
--     p.date_of_birth AS player_date_of_birth,
--     p.email AS player_email,
--     p.address AS player_address,
--     p.username AS player_username,
--     a.account_id,
--     a.balance AS account_balance,
--     a.status AS account_status,
--     t.transaction_id,
--     t.amount AS transaction_amount,
--     t.status AS transaction_status,
--     t.timestamp AS transaction_timestamp,
--     g.game_id,
--     g.title AS game_title,
--     g.rating AS game_rating,
--     g.genre AS game_genre,
--     g.publisher AS game_publisher,
--     g.release_date AS game_release_date,
--     tr.tournament_id,
--     tr.start_date AS tournament_start_date,
--     tr.end_time AS tournament_end_time,
--     tr.prize AS tournament_prize,
--     m.manager_id,
--     m.name AS manager_name,
--     m.date_of_birth AS manager_date_of_birth,
--     m.address AS manager_address,
--     e.employee_id,
--     e.job_title AS employee_job_title
-- FROM
--     player p
--     LEFT JOIN Account a ON p.player_id = a.player_id
--     LEFT JOIN Transaction t ON a.account_id = t.account_id
--     LEFT JOIN Game g ON t.game_id = g.game_id
--     LEFT JOIN Tournament tr ON g.game_id = tr.game_id
--     LEFT JOIN PlayerGame pg ON p.player_id = pg.player_id
--     LEFT JOIN Employee e ON pg.employee_id = e.employee_id
--     LEFT JOIN Manager m ON e.employee_id = m.employee_id;
--
-- -- Player dashboard view
-- CREATE OR REPLACE VIEW player_overview AS
-- SELECT
--     p.player_id,
--     p.name AS player_name,
--     p.date_of_birth,
--     p.email,
--     p.address,
--     p.username,
--     a.account_id,
--     a.balance,
--     a.status AS account_status,
--     t.transaction_id,
--     t.amount,
--     t.status AS transaction_status,
--     g.game_id,
--     g.title AS game_title,
--     g.rating,
--     g.genre,
--     g.publisher,
--     g.release_date
-- FROM
--     Player p
--     JOIN Account a ON p.player_id = a.player_id
--     LEFT JOIN Transaction t ON a.account_id = t.account_id
--     LEFT JOIN PlayerGame pg ON p.player_id = pg.player_id
--     LEFT JOIN Game g ON pg.game_id = g.game_id;
--
-- CREATE OR REPLACE VIEW manager_overview AS
-- SELECT
--     m.manager_id,
--     m.name AS manager_name,
--     m.date_of_birth,
--     m.address,
--     e.employee_id,
--     e.job_title,
--     e.name AS employee_name,
--     e.date_of_birth AS employee_dob,
--     e.address AS employee_address,
--     t.transaction_id,
--     t.amount,
--     t.status AS transaction_status,
--     g.game_id,
--     g.title AS game_title,
--     g.rating,
--     g.genre,
--     g.publisher,
--     g.release_date
-- FROM
--     Manager m
--     JOIN Employee e ON m.employee_id = e.employee_id
--     LEFT JOIN Transaction t ON m.manager_id = t.manager_id
--     LEFT JOIN Game g ON t.game_id = g.game_id;
--
-- CREATE VIEW player_assistance_log AS
-- SELECT
--     e.employee_id,
--     e.name AS employee_name,
--     p.player_id,
--     p.name AS player_name,
--     t.transaction_id,
--     t.timestamp,
--     t.amount,
--     t.status
-- FROM
--     Employee e
--     JOIN Transaction t ON e.employee_id = t.manager_id
--     JOIN Player p ON t.player_id = p.player_id;
--
-- CREATE VIEW game_inventory AS
-- SELECT
--     g.game_id,
--     g.title,
--     g.publisher,
--     COUNT(tg.transaction_id) AS total_sold,
--     COUNT(tg.transaction_id) AS remaining_stock
-- FROM Game g
--     LEFT JOIN TransactionGame tg ON g.game_id = tg.game_id
-- GROUP BY
--     g.game_id,
--     g.title,
--     g.publisher;
--
-- -- Create functions
--
-- -- Function to calculate the total balance of a player's account
-- CREATE OR REPLACE FUNCTION get_total_balance(player_id
-- INT) RETURNS DECIMAL AS
-- $$
-- DECLARE
-- 	total_balance DECIMAL;
-- BEGIN
-- 	SELECT SUM(balance) into total_balance
-- 	FROM Account
-- 	WHERE
-- 	    player_id = get_total_balance.player_id;
-- 	RETURN total_balance;
-- END
-- $$
-- LANGUAGE
-- plpgsql;
--
-- -- Function to get the count of transactions for a player
-- CREATE OR REPLACE FUNCTION get_transaction_count(player_id
-- INT) RETURNS INT AS
-- $$
-- DECLARE
-- 	transaction_count INT;
-- BEGIN
-- 	SELECT COUNT(*) INTO transaction_count
-- 	FROM Transaction t
-- 	    JOIN Account a ON t.account_id = a.account_id
-- 	WHERE
-- 	    a.player_id = get_transaction_count.player_id;
-- 	RETURN transaction_count;
-- END;
-- $$
-- LANGUAGE
-- plpgsql;
--
-- -- Function to get the average rating of games in a given source
-- CREATE OR REPLACE FUNCTION get_average_rating_by_genre
-- (genre VARCHAR) RETURNS DECIMAL AS
-- $$
-- DECLARE
-- 	avg_rating DECIMAL;
-- BEGIN
-- 	SELECT AVG(rating) INTO avg_rating
-- 	FROM Game
-- 	WHERE
-- 	    genre = get_average_rating_by_genre.genre;
-- 	RETURN avg_rating;
-- END;
-- $$
-- LANGUAGE
-- plpgsql;