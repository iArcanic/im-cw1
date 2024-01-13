-- im-cw1/sql/views-functions/create_views.sql

-- Admin dashboard view
CREATE
OR
REPLACE VIEW admin_overview AS
SELECT
    p.player_id,
    p.name AS player_name,
    p.date_of_birth AS player_date_of_birth,
    p.email AS player_email,
    p.address AS player_address,
    p.username AS player_username,
    a.account_id,
    a.balance AS account_balance,
    a.status AS account_status,
    t.transaction_id,
    t.amount AS transaction_amount,
    t.status AS transaction_status,
    t.timestamp AS transaction_timestamp,
    g.game_id,
    g.title AS game_title,
    g.rating AS game_rating,
    g.genre AS game_genre,
    g.publisher AS game_publisher,
    g.release_date AS game_release_date,
    tr.tournament_id,
    tr.start_date AS tournament_start_date,
    tr.end_time AS tournament_end_time,
    tr.prize AS tournament_prize,
    m.manager_id,
    m.name AS manager_name,
    m.date_of_birth AS manager_date_of_birth,
    m.address AS manager_address,
    e.employee_id,
    e.job_title AS employee_job_title
FROM player p
    LEFT JOIN Account a ON p.player_id = a.player_id
    LEFT JOIN Transaction t ON a.account_id = t.account_id
    LEFT JOIN Game g ON t.game_id = g.game_id
    LEFT JOIN Tournament tr ON g.game_id = tr.game_id
    LEFT JOIN PlayerGame pg ON p.player_id = pg.player_id
    LEFT JOIN Employee e ON pg.employee_id = e.employee_id
    LEFT JOIN Manager m ON e.employee_id = m.employee_id;

-- Player dashboard view
CREATE
OR
REPLACE VIEW player_overview AS
SELECT
    p.player_id,
    p.name AS player_name,
    p.date_of_birth,
    p.email,
    p.address,
    p.username,
    a.account_id,
    a.balance,
    a.status AS account_status,
    t.transaction_id,
    t.amount,
    t.status AS transaction_status,
    g.game_id,
    g.title AS game_title,
    g.rating,
    g.genre,
    g.publisher,
    g.release_date
FROM Player p
    JOIN Account a ON p.player_id = a.player_id
    LEFT JOIN Transaction t ON a.account_id = t.account_id
    LEFT JOIN PlayerGame pg ON p.player_id = pg.player_id
    LEFT JOIN Game g ON pg.game_id = g.game_id;

CREATE
OR
REPLACE
    VIEW manager_overview AS
SELECT
    m.manager_id,
    m.name AS manager_name,
    m.date_of_birth,
    m.address,
    e.employee_id,
    e.job_title,
    e.name AS employee_name,
    e.date_of_birth AS employee_dob,
    e.address AS employee_address,
    t.transaction_id,
    t.amount,
    t.status AS transaction_status,
    g.game_id,
    g.title AS game_title,
    g.rating,
    g.genre,
    g.publisher,
    g.release_date
FROM Manager m
    JOIN Employee e ON m.employee_id = e.employee_id
    LEFT JOIN Transaction t ON m.manager_id = t.manager_id
    LEFT JOIN Game g ON t.game_id = g.game_id;

CREATE VIEW
    player_assistance_log AS
SELECT
    e.employee_id,
    e.name AS employee_name,
    p.player_id,
    p.name AS player_name,
    t.transaction_id,
    t.timestamp,
    t.amount,
    t.status
FROM Employee e
    JOIN Transaction t ON e.employee_id = t.manager_id
    JOIN Player p ON t.player_id = p.player_id;