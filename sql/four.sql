-- CREATE PROCEDURES

CREATE OR REPLACE FUNCTION CalculateTotalInGameBalance(player_id INT)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
total_balance DECIMAL(10, 2);
BEGIN
SELECT
    COALESCE(SUM(Balance), 0)
INTO
    total_balance
FROM
    AccountSchema.InGamePlayerAccounts
WHERE
        PlayerID = player_id;

RETURN total_balance;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ApproveGameTransaction(transaction_id INT, approver_id INT)
RETURNS VOID AS $$
BEGIN
UPDATE
    TransactionSchema.GameTransactionApprovals
SET
    ApprovalStatus = 'Approved'
WHERE
        GameTransactionID = transaction_id
  AND EmployeeID = approver_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetTopRatedGames(limit_count INT)
RETURNS TABLE (
    game_id INT,
    title VARCHAR,
    average_rating NUMERIC
) AS $$
BEGIN
RETURN QUERY
SELECT
    G.GameID,
    G.Title,
    AVG(G.Rating) AS AverageRating
FROM
    GameSchema.Games G
GROUP BY
    G.GameID, G.Title
ORDER BY
    AverageRating DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- CREATE PROCEDURES

CREATE OR REPLACE PROCEDURE ProcessGamePurchase(
    player_id INT,
    game_id INT,
    purchase_amount DECIMAL(10, 2)
)
AS $$
BEGIN
    BEGIN

    UPDATE AccountSchema.PlayerAccounts
    SET Balance = Balance - purchase_amount
    WHERE PlayerID = player_id;

    INSERT INTO TransactionSchema.GameTransactions (PlayerAccountID, GameID, Amount)
    VALUES (player_id, game_id, purchase_amount);

    COMMIT;
    EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END;
END;
$$ LANGUAGE plpgsql;