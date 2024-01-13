-- im-cw1/sql/tables/create_relationships.sql

-- EmployeeGame (Many-to-Many between Employee and Game)
ALTER TABLE EmployeeGame
ADD
    CONSTRAINT fk_employeegame_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

ALTER TABLE EmployeeGame
ADD
    CONSTRAINT fk_employeegame_game FOREIGN KEY (game_id) REFERENCES Game(game_id);

-- PlayerGame (Many-to-Many between Player and Game)
ALTER TABLE PlayerGame
ADD
    CONSTRAINT fk_playergame_player FOREIGN KEY (player_id) REFERENCES Player(player_id);

ALTER TABLE PlayerGame
ADD
    CONSTRAINT fk_playergame_game FOREIGN KEY (game_id) REFERENCES Game(game_id);

-- TransactionGame (Many-to-Many between Transaction and Game)
ALTER TABLE TransactionGame
ADD
    CONSTRAINT fk_transactiongame_transaction FOREIGN KEY (transaction_id) REFERENCES Transaction(transaction_id);

ALTER TABLE TransactionGame
ADD
    CONSTRAINT fk_transactiongame_game FOREIGN KEY (game_id) REFERENCES Game(game_id);

-- Employee to Manager (One-to-One)
ALTER TABLE Manager
ADD
    CONSTRAINT fk_manager_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

-- Player to Employee (Many-to-One)
ALTER TABLE Player
ADD
    CONSTRAINT fk_player_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

-- Account to Player (Many-to-One)
ALTER TABLE Account
ADD
    CONSTRAINT fk_account_player FOREIGN KEY (player_id) REFERENCES Player(player_id);

-- Transaction to Account (Many-to-One)
ALTER TABLE Transaction
ADD
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES Account(account_id);

-- Transaction to Manager (Many-to-One)
ALTER TABLE Transaction
ADD
    CONSTRAINT fk_transaction_manager FOREIGN KEY (manager_id) REFERENCES Manager(manager_id);

-- Game to Tournament (One-to-Many)
ALTER TABLE Tournament
ADD
    CONSTRAINT fk_tournament_game FOREIGN KEY (game_id) REFERENCES Game(game_id);