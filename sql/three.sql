-- CREATE VIEWS

CREATE VIEW PlayerSchema.PlayerDashboard AS
SELECT
    P.PlayerID,
    P.Username,
    PA.Balance AS MainAccountBalance
FROM
    PlayerSchema.Players P
        JOIN
    AccountSchema.PlayerAccounts PA ON P.PlayerID = PA.PlayerID;

CREATE VIEW GameSchema.GameCatalog AS
SELECT
    GameID,
    Title,
    Genre,
    ReleaseDate
FROM
    GameSchema.Games;

CREATE VIEW TransactionSchema.TransactionHistory AS
SELECT
    GT.GameTransactionID AS TransactionID,
    P.Username AS PlayerUsername,
    G.Title AS GameTitle,
    GT.Amount,
    GT.TransactionDate,
    GTA.ApprovalStatus AS TransactionApprovalStatus
FROM
    TransactionSchema.GameTransactions GT
        JOIN
    PlayerSchema.Players P ON GT.PlayerAccountID = P.PlayerID
        JOIN
    GameSchema.Games G ON GT.GameID = G.GameID
        LEFT JOIN
    TransactionSchema.GameTransactionApprovals GTA ON GT.GameTransactionID = GTA.GameTransactionID;

CREATE VIEW EmployeeSchema.ManagerDashboard AS
SELECT
    P.PlayerID,
    P.Username,
    P.Fullname,
    P.Email,
    PA.Balance AS MainAccountBalance,
    IPA.Balance AS InGameAccountBalance
FROM
    PlayerSchema.Players P
        LEFT JOIN
    AccountSchema.PlayerAccounts PA ON P.PlayerID = PA.PlayerID
        LEFT JOIN
    AccountSchema.InGamePlayerAccounts IPA ON P.PlayerID = IPA.PlayerID;
