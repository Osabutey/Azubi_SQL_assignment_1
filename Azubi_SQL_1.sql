-- A simplified version of some of the tables in our postgres db
schema.
-- Don't worry if you don't need to use all of the columns!
CREATE TABLE users (
u_id integer PRIMARY KEY,
name text NOT NULL,
mobile text NOT NULL,
wallet_id integer NOT NULL,
when_created timestamp without time zone NOT NULL
);

CREATE TABLE transfers (
transfer_id integer PRIMARY KEY,
u_id integer NOT NULL,
source_wallet_id integer NOT NULL,
dest_wallet_id integer NOT NULL,
send_amount_currency text NOT NULL,
send_amount_scalar numeric NOT NULL,
receive_amount_currency text NOT NULL,
receive_amount_scalar numeric NOT NULL,
kind text NOT NULL,
dest_mobile text,
dest_merchant_id integer,
when_created timestamp without time zone NOT NULL
);

CREATE TABLE agents (
agent_id integer PRIMARY KEY,name text,
country text NOT NULL,
region text,
city text,
subcity text,
when_created timestamp without time zone NOT NULL
);

CREATE TABLE agent_transactions (
atx_id integer PRIMARY KEY,
u_id integer NOT NULL,
agent_id integer NOT NULL,
amount numeric NOT NULL,
fee_amount_scalar numeric NOT NULL,
when_created timestamp without time zone NOT NULL
);

CREATE TABLE wallets (
wallet_id integer PRIMARY KEY,
currency text NOT NULL,
ledger_location text NOT NULL,
when_created timestamp without time zone NOT NULL
);


--QUESTION 1
--How Many User does wave have?
SELECT COUNT(u_id) FROM users 

--QUESTION 2
--How many transfers have been sent in the currency CFA?
SELECT  COUNT(transfer_id) FROM transfers WHERE send_amount_currency = 'CFA'

--QUESTION 3
--How many different users have sent a transfer in CFA?
SELECT COUNT(DISTINCT u_id) FROM transfers WHERE send_amount_currency = 'CFA'

--QUESTION 4
--How many agent_transactions did we have in the months of 2018
SELECT  COUNT(atx_id) FROM agent_transactions 
WHERE EXTRACT(YEAR FROM when_created)=2018 
GROUP BY EXTRACT(MONTH FROM when_created)

--QUESTION 5
SELECT status, COUNT(status) FROM (
SELECT SUM(amount),
CASE
 WHEN SUM(amount)>0 THEN 'net depositors'
 WHEN SUM(amount)<0 THEN 'net withdrawer'
END AS status 
FROM agent_transactions
WHERE when_created > NOW() - INTERVAL '7days'
GROUP BY u_id
ORDER BY u_id ASC
) 
AS net
GROUP BY status
;

--QUESTION 6
SELECT count(atx.amount) AS "atx volume city summary"  ,ag.city 
FROM agent_transactions AS atx LEFT OUTER JOIN agents AS ag ON
atx.atx_id = ag.agent_id
WHERE atx.when_created BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
AND NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER 
GROUP BY ag.city

--QUESTION 7
SELECT count(ag.country) AS "Country", count(ag.city) AS "City",count(atx.amount) AS "atx volume"
FROM agent_transactions AS atx INNER JOIN agents AS ag ON
atx.atx_id = ag.agent_id
GROUP BY ag.country 

--QUESTION 8
SELECT w.ledger_location as "Country",tn.send_amount_currency AS "Kind",
sum(tn.send_amount_scalar) AS "Volume"
FROM transfers AS tn INNER JOIN wallets AS w ON tn.transfer_id = w.wallet_id
WHERE tn.when_created = CURRENT_DATE-INTERVAL '1 week'
GROUP BY w.ledger_location ,tn.send_amount_currency

--QUESTION 9
SELECT COUNT(transfers.source_wallet_id) 
AS Unique_Senders, 
COUNT (transfer_id) 
AS Transaction_Count, transfers.kind 
AS Transfer_Kind, wallets.ledger_location 
AS Country, 
SUM (transfers.send_amount_scalar) 
AS Volume 
FROM transfers 
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind; 

--QUESTION 10
SELECT w.wallet_id,tn.source_wallet_id, tn.send_amount_scalar
FROM transfers AS tn INNER JOIN wallets AS w ON tn.transfer_id = w.wallet_id
WHERE tn.send_amount_scalar > 10000000 AND 
(tn.send_amount_currency = 'CFA' AND tn.when_created >
CURRENT_DATE-INTERVAL '1 month')
