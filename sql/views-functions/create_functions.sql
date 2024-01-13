-- im-cw1/sql/views-functions/create_functions.sql

-- Function to calculate the total balance of a player's account
CREATE OR REPLACE FUNCTION get_total_balance(player_id 
INT) RETURNS DECIMAL AS 
	$$ DECLARE total_balance DECIMAL;
	BEGIN
	SELECT
	    SUM (balance) into total_balance
	FROM Account
	WHERE
	    player_id = get_total_balance.player_id;
	RETURN total_balance;
	END $$ LANGUAGE
plpgsql; 

-- Function to get the count of transactions for a player
CREATE OR REPLACE FUNCTION get_transaction_count(player_id 
INT) RETURNS INT AS 
	$$ DECLARE transaction_count INT;
	BEGIN
	SELECT
	    COUNT (*) INTO transaction_count
	FROM Transaction t
	    JOIN Account a ON t.account_id = a.account_id
	WHERE
	    a.player_id = get_transaction_count.player_id;
	RETURN transaction_count;
	END;
	$$ LANGUAGE
plpgsql; 