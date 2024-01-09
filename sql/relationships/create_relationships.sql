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