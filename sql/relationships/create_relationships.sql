-- im-cw1/sql/tables/create_relationships.sql

-- EmployeeGame (Many-to-Many between Employee and Game)
ALTER TABLE EmployeeGame
ADD
    CONSTRAINT fk_employeegame_employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

ALTER TABLE EmployeeGame
ADD
    CONSTAINT fk_employeegame_game FOREIGN KEY (game_id) REFERENCES Game(game_id);