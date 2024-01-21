-- CREATE TABLES

CREATE TABLE IF NOT EXISTS PlayerSchema.Players (
    PlayerID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Fullname VARCHAR(255) NOT NULL,
    DateOfBirth DATE,
    Address TEXT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS AccountSchema.PlayerAccounts (
    PlayerAccountID SERIAL PRIMARY KEY,
    PlayerID SERIAL,
    Balance DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS AccountSchema.InGamePlayerAccounts (
    InGamePlayerAccountID SERIAL PRIMARY KEY,
    PlayerID SERIAL,
    GameID SERIAL,
    Balance DECIMAL(10, 2) DEFAULT 0.00,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS GameSchema.Games (
    GameID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Rating VARCHAR(10),
    Genre VARCHAR(50),
    Publisher VARCHAR(255),
    ReleaseDate DATE
);

CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactions (
    GameTransactionID SERIAL PRIMARY KEY,
    PlayerAccountID SERIAL,
    GameID SERIAL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactions (
    InGameTransactionID SERIAL PRIMARY KEY,
    InGamePlayerAccountID SERIAL,
    GameID SERIAL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactionApprovals (
    GameTransactionApprovalID SERIAL PRIMARY KEY,
    GameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactionApprovals (
    InGameTransactionApprovalID SERIAL PRIMARY KEY,
    InGameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS EmployeeSchema.Employees (
    EmployeeID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Fullname VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS EmployeeSchema.PlayerSupport (
    PlayerSupportID SERIAL PRIMARY KEY,
    EmployeeID SERIAL,
    PlayerID SERIAL,
    Notes TEXT,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ESportsSchema.Teams (
    TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ESportsSchema.Tournament (
    TournamentID SERIAL PRIMARY KEY,
    GameID SERIAL,
    TournamentName VARCHAR(255) NOT NULL,
    StartDate TIMESTAMP,
    EndDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ESportsSchema.TeamPlayers (
    TeamPlayerID SERIAL PRIMARY KEY,
    TeamID SERIAL,
    PlayerID SERIAL
);

CREATE TABLE IF NOT EXISTS ESportsSchema.TournamentResults (
    TournamentResultID SERIAL PRIMARY KEY,
    TournamentID SERIAL,
    TeamID SERIAL,
    TournamentResultStatus TournamentResultStatus NOT NULL
);

ALTER TABLE AccountSchema.PlayerAccounts
    ADD CONSTRAINT fk_PlayerID_PlayerAccounts FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players(PlayerID);

ALTER TABLE AccountSchema.InGamePlayerAccounts
    ADD CONSTRAINT fk_PlayerID_InGamePlayerAccounts FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players(PlayerID);
ALTER TABLE AccountSchema.InGamePlayerAccounts
    ADD CONSTRAINT fk_GameID_InGamePlayerAccounts FOREIGN KEY (GameID) REFERENCES GameSchema.Games(GameID);

ALTER TABLE TransactionSchema.GameTransactions
    ADD CONSTRAINT fk_PlayerAccountID_GameTransactions FOREIGN KEY (PlayerAccountID) REFERENCES AccountSchema.PlayerAccounts(PlayerAccountID);
ALTER TABLE TransactionSchema.GameTransactions
    ADD CONSTRAINT fk_GameID_GameTransactions FOREIGN KEY (GameID) REFERENCES GameSchema.Games(GameID);

ALTER TABLE TransactionSchema.InGameTransactions
    ADD CONSTRAINT fk_InGamePlayerAccountID_InGameTransactions FOREIGN KEY (InGamePlayerAccountID) REFERENCES AccountSchema.InGamePlayerAccounts(InGamePlayerAccountID);
ALTER TABLE TransactionSchema.InGameTransactions
    ADD CONSTRAINT fk_GameID_InGameTransactions FOREIGN KEY (GameID) REFERENCES GameSchema.Games(GameID);

ALTER TABLE TransactionSchema.GameTransactionApprovals
    ADD CONSTRAINT fk_GameTransactionID_GameTransactionApprovals FOREIGN KEY (GameTransactionID) REFERENCES TransactionSchema.GameTransactions(GameTransactionID);
ALTER TABLE TransactionSchema.GameTransactionApprovals
    ADD CONSTRAINT fk_EmployeeID_GameTransactionApprovals FOREIGN KEY (EmployeeID) REFERENCES EmployeeSchema.Employees(EmployeeID);

ALTER TABLE TransactionSchema.InGameTransactionApprovals
    ADD CONSTRAINT fk_InGameTransactionID_InGameTransactionApprovals FOREIGN KEY (InGameTransactionID) REFERENCES TransactionSchema.InGameTransactions(InGameTransactionID);
ALTER TABLE TransactionSchema.InGameTransactionApprovals
    ADD CONSTRAINT fk_EmployeeID_InGameTransactionApprovals FOREIGN KEY (EmployeeID) REFERENCES EmployeeSchema.Employees(EmployeeID);

ALTER TABLE ESportsSchema.Tournament
    ADD CONSTRAINT fk_GameID_Tournament FOREIGN KEY (GameID) REFERENCES GameSchema.Games(GameID);

ALTER TABLE ESportsSchema.TeamPlayers
    ADD CONSTRAINT fk_TeamID_TeamPlayers FOREIGN KEY (TeamID) REFERENCES ESportsSchema.Teams(TeamID);
ALTER TABLE ESportsSchema.TeamPlayers
    ADD CONSTRAINT fk_PlayerID_TeamPlayers FOREIGN KEY (PlayerID) REFERENCES PlayerSchema.Players(PlayerID);

ALTER TABLE ESportsSchema.TournamentResults
    ADD CONSTRAINT fk_TournamentID_TournamentResults FOREIGN KEY (TournamentID) REFERENCES ESportsSchema.Tournament(TournamentID);
ALTER TABLE ESportsSchema.TournamentResults
    ADD CONSTRAINT fk_TeamID_TournamentResults FOREIGN KEY (TeamID) REFERENCES ESportsSchema.Teams(TeamID);