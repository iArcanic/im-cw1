-- Turn on quit when error
\set ON_ERROR_STOP on
-- CREATE DATABASE
CREATE DATABASE gamingplatform;

-- USE DATABASE
\c gamingplatform
-- SCHEMA CREATION
CREATE SCHEMA PlayerSchema;

CREATE SCHEMA AccountSchema;

CREATE SCHEMA GameSchema;

CREATE SCHEMA TransactionSchema;

CREATE SCHEMA EmployeeSchema;

CREATE SCHEMA ESportsSchema;

-- ROLE CREATION
CREATE ROLE PlayerRole;

CREATE ROLE EmployeeRole;

CREATE ROLE ManagerRole;

-- GRANT SCHEMA PERMISSIONS
GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA PlayerSchema TO PlayerRole;

GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA AccountSchema TO PlayerRole;

GRANT SELECT ON ALL TABLES IN SCHEMA GameSchema TO PlayerRole;

GRANT SELECT ON ALL TABLES IN SCHEMA ESportsSchema TO PlayerRole;

GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA EmployeeSchema TO EmployeeRole;

GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA PlayerSchema TO EmployeeRole;

GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA AccountSchema TO EmployeeRole;

GRANT
SELECT,
INSERT
    ON ALL TABLES IN SCHEMA TransactionSchema TO EmployeeRole;

GRANT
SELECT,
INSERT
,
UPDATE ON ALL TABLES IN SCHEMA ESportsSchema TO EmployeeRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PlayerSchema TO ManagerRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA AccountSchema TO ManagerRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA GameSchema TO ManagerRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA TransactionSchema TO ManagerRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA EmployeeSchema TO ManagerRole;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ESportsSchema TO ManagerRole;

-- CREATE ENUMS
CREATE TYPE EmployeeRole AS ENUM('Employee', 'Manager');

CREATE TYPE ApprovalStatus AS ENUM(
    'Pending', 'Approved', 'Rejected'
);

CREATE TYPE TournamentResultStatus AS ENUM(
    'First', 'Second', 'Third', 'Discontinued'
);

-- CREATE TABLES

CREATE TABLE IF NOT EXISTS PlayerSchema.Players (
    PlayerID SERIAL PRIMARY KEY, Username VARCHAR(50) NOT NULL UNIQUE, Password VARCHAR(100) NOT NULL, Fullname VARCHAR(255) NOT NULL, DateOfBirth DATE, Address TEXT, Email VARCHAR(100) NOT NULL UNIQUE, RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS AccountSchema.PlayerAccounts (
    PlayerAccountID SERIAL PRIMARY KEY, PlayerID SERIAL, Balance DECIMAL(10, 2) DEFAULT 0.00, UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS AccountSchema.InGamePlayerAccounts (
    InGamePlayerAccountID SERIAL PRIMARY KEY, PlayerID SERIAL, GameID SERIAL, Balance DECIMAL(10, 2) DEFAULT 0.00, UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS GameSchema.Games (
    GameID SERIAL PRIMARY KEY, Title VARCHAR(255) NOT NULL, Rating VARCHAR(10), Genre VARCHAR(50), Publisher VARCHAR(255), ReleaseDate DATE
);

CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactions (
    GameTransactionID SERIAL PRIMARY KEY, PlayerAccountID SERIAL, GameID SERIAL, Amount DECIMAL(10, 2) NOT NULL, TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactions (
    InGameTransactionID SERIAL PRIMARY KEY, InGamePlayerAccountID SERIAL, GameID SERIAL, Amount DECIMAL(10, 2) NOT NULL, TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactionApprovals (
    GameTransactionApprovalID SERIAL PRIMARY KEY, GameTransactionID SERIAL, EmployeeID SERIAL, ApprovalStatus ApprovalStatus NOT NULL, UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactionApprovals (
    InGameTransactionApprovalID SERIAL PRIMARY KEY, InGameTransactionID SERIAL, EmployeeID SERIAL, ApprovalStatus ApprovalStatus NOT NULL, UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS EmployeeSchema.Employees (
    EmployeeID SERIAL PRIMARY KEY, Username VARCHAR(50) NOT NULL UNIQUE, Fullname VARCHAR(255) NOT NULL, EmployeeRole EmployeeRole NOT NULL
);

CREATE TABLE IF NOT EXISTS EmployeeSchema.PlayerSupport (
    PlayerSupportID SERIAL PRIMARY KEY, EmployeeID SERIAL, PlayerID SERIAL, Notes TEXT, UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ESportsSchema.Teams (
    TeamID SERIAL PRIMARY KEY, TeamName VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ESportsSchema.Tournament (
    TournamentID SERIAL PRIMARY KEY, GameID SERIAL, TournamentName VARCHAR(255) NOT NULL, StartDate TIMESTAMP, EndDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ESportsSchema.TeamPlayers (
    TeamPlayerID SERIAL PRIMARY KEY, TeamID SERIAL, PlayerID SERIAL
);

CREATE TABLE IF NOT EXISTS ESportsSchema.TournamentResults (
    TournamentResultID SERIAL PRIMARY KEY, TournamentID SERIAL, TeamID SERIAL, TournamentResultStatus TournamentResultStatus NOT NULL
);

ALTER TABLE AccountSchema.PlayerAccounts
ADD CONSTRAINT fk_PlayerID_PlayerAccounts FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players (PlayerID);

ALTER TABLE AccountSchema.InGamePlayerAccounts
ADD CONSTRAINT fk_PlayerID_InGamePlayerAccounts FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players (PlayerID);

ALTER TABLE AccountSchema.InGamePlayerAccounts
ADD CONSTRAINT fk_GameID_InGamePlayerAccounts FOREIGN KEY (GameID) REFERENCES GameSchema.Games (GameID);

ALTER TABLE TransactionSchema.GameTransactions
ADD CONSTRAINT fk_PlayerAccountID_GameTransactions FOREIGN KEY (PlayerAccountID) REFERENCES AccountSchema.PlayerAccounts (PlayerAccountID);

ALTER TABLE TransactionSchema.GameTransactions
ADD CONSTRAINT fk_GameID_GameTransactions FOREIGN KEY (GameID) REFERENCES GameSchema.Games (GameID);

ALTER TABLE TransactionSchema.InGameTransactions
ADD CONSTRAINT fk_InGamePlayerAccountID_InGameTransactions FOREIGN KEY (InGamePlayerAccountID) REFERENCES AccountSchema.InGamePlayerAccounts (InGamePlayerAccountID);

ALTER TABLE TransactionSchema.InGameTransactions
ADD CONSTRAINT fk_GameID_InGameTransactions FOREIGN KEY (GameID) REFERENCES GameSchema.Games (GameID);

ALTER TABLE TransactionSchema.GameTransactionApprovals
ADD CONSTRAINT fk_GameTransactionID_GameTransactionApprovals FOREIGN KEY (GameTransactionID) REFERENCES TransactionSchema.GameTransactions (GameTransactionID);

ALTER TABLE TransactionSchema.GameTransactionApprovals
ADD CONSTRAINT fk_EmployeeID_GameTransactionApprovals FOREIGN KEY (EmployeeID) REFERENCES EmployeeSchema.Employees (EmployeeID);

ALTER TABLE TransactionSchema.InGameTransactionApprovals
ADD CONSTRAINT fk_InGameTransactionID_InGameTransactionApprovals FOREIGN KEY (InGameTransactionID) REFERENCES TransactionSchema.InGameTransactions (InGameTransactionID);

ALTER TABLE TransactionSchema.InGameTransactionApprovals
ADD CONSTRAINT fk_EmployeeID_InGameTransactionApprovals FOREIGN KEY (EmployeeID) REFERENCES EmployeeSchema.Employees (EmployeeID);

ALTER TABLE ESportsSchema.Tournament
ADD CONSTRAINT fk_GameID_Tournament FOREIGN KEY (GameID) REFERENCES GameSchema.Games (GameID);

ALTER TABLE ESportsSchema.TeamPlayers
ADD CONSTRAINT fk_TeamID_TeamPlayers FOREIGN KEY (TeamID) REFERENCES ESportsSchema.Teams (TeamID);

ALTER TABLE ESportsSchema.TeamPlayers
ADD CONSTRAINT fk_PlayerID_TeamPlayers FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players (PlayerID);

ALTER TABLE ESportsSchema.TournamentResults
ADD CONSTRAINT fk_TournamentID_TournamentResults FOREIGN KEY (TournamentID) REFERENCES ESportsSchema.Tournament (TournamentID);

ALTER TABLE ESportsSchema.TournamentResults
ADD CONSTRAINT fk_TeamID_TournamentResults FOREIGN KEY (TeamID) REFERENCES ESportsSchema.Teams (TeamID);

-- CREATE VIEWS

CREATE VIEW PlayerSchema.PlayerDashboard AS
SELECT P.PlayerID, P.Username, PA.Balance AS MainAccountBalance
FROM PlayerSchema.Players P
    JOIN AccountSchema.PlayerAccounts PA ON P.PlayerID = PA.PlayerID;

CREATE VIEW GameSchema.GameCatalog AS
SELECT GameID, Title, Genre, ReleaseDate
FROM GameSchema.Games;

CREATE VIEW TransactionSchema.TransactionHistory AS
SELECT
    GT.GameTransactionID AS TransactionID,
    P.Username AS PlayerUsername,
    G.Title AS GameTitle,
    GT.Amount,
    GT.TransactionDate,
    GTA.ApprovalStatus AS TransactionApprovalStatus
FROM TransactionSchema.GameTransactions GT
    JOIN PlayerSchema.Players P ON GT.PlayerAccountID = P.PlayerID
    JOIN GameSchema.Games G ON GT.GameID = G.GameID
    LEFT JOIN TransactionSchema.GameTransactionApprovals GTA ON GT.GameTransactionID = GTA.GameTransactionID;

CREATE VIEW EmployeeSchema.ManagerDashboard AS
SELECT
    P.PlayerID,
    P.Username,
    P.Fullname,
    P.Email,
    PA.Balance AS MainAccountBalance,
    IPA.Balance AS InGameAccountBalance
FROM PlayerSchema.Players P
    LEFT JOIN AccountSchema.PlayerAccounts PA ON P.PlayerID = PA.PlayerID
    LEFT JOIN AccountSchema.InGamePlayerAccounts IPA ON P.PlayerID = IPA.PlayerID;

-- CREATE PROCEDURES

CREATE OR REPLACE FUNCTION CalculateTotalInGameBalance
(player_id INT) RETURNS DECIMAL(10, 2) AS 
$$
DECLARE
	total_balance DECIMAL(10, 2);
BEGIN
	SELECT COALESCE(SUM(Balance), 0) INTO total_balance
	FROM AccountSchema.InGamePlayerAccounts
	WHERE
	    PlayerID = player_id;
	RETURN total_balance;
END;
$$
LANGUAGE
plpgsql; 

CREATE OR REPLACE FUNCTION ApproveGameTransaction(transaction_id 
INT, approver_id INT) RETURNS VOID AS 
$$
BEGIN
	UPDATE TransactionSchema.GameTransactionApprovals
	SET
	    ApprovalStatus = 'Approved'
	WHERE
	    GameTransactionID = transaction_id
	    AND EmployeeID = approver_id;
END;
$$
LANGUAGE
plpgsql; 

CREATE OR REPLACE FUNCTION GetTopRatedGames(limit_count 
INT) RETURNS TABLE(game_id INT, title VARCHAR, average_rating 
NUMERIC) AS 
$$
BEGIN
	RETURN QUERY
	SELECT G.GameID, G.Title, AVG(G.Rating) AS AverageRating
	FROM GameSchema.Games G
	GROUP BY
	    G.GameID,
	    G.Title
	ORDER BY AverageRating DESC
	LIMIT limit_count;
END;
$$
LANGUAGE
plpgsql; 

-- CREATE PROCEDURES

CREATE OR REPLACE PROCEDURE ProcessGamePurchase(player_id 
INT, game_id INT, purchase_amount DECIMAL(10, 2)) AS 
$$
BEGIN
BEGIN
	UPDATE AccountSchema.PlayerAccounts
	SET
	    Balance = Balance - purchase_amount
	WHERE
	    PlayerID = player_id;
	INSERT INTO
	    TransactionSchema.GameTransactions (
	        PlayerAccountID, GameID, Amount
	    )
	VALUES (
	        player_id, game_id, purchase_amount
	    );
	COMMIT;
	EXCEPTION WHEN OTHERS THEN ROLLBACK;
	RAISE;
END;
END;
$$
LANGUAGE
plpgsql; 

\echo "Successfully migrated database" 