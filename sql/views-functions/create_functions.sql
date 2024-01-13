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