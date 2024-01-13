-- im-cw1/sql/views-functions/create_views.sql

-- Admin dashboard view
CREATE VIEW admin_overview AS
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
    LEFT JOIN account a ON p.player_id = a.player_id
    LEFT JOIN transaction t ON a.account_id = t.account_id
    LEFT JOIN game g ON t.game_id = g.game_id
    LEFT JOIN tournament tr ON g.game_id = tr.game_id
    LEFT JOIN playergame pg ON p.player_id = pg.player_id
    LEFT JOIN employee e ON pg.employee_id = e.employee_id
    LEFT JOIN manager m ON e.employee_id = m.employee_id;