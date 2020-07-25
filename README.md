# Azubi_SQL_assignment

Here is a an analysis of the transactions done through the use of WAVE APP. 

The following steps were taken to answer the underlisted questions
1. The nature of the business/ app was studied to understand the operations
2. A sample data was collected to understand the data in the app
3. The schema was drawn as a framework of how the tables should created
4. Tables were created in the Posgresql 

CREATE TABLE users (
u_id integer PRIMARY KEY,
name text NOT NULL,
mobile text NOT NULL,
wallet_id integer NOT NULL,
when_created timestamp without time zone NOT NULL
-- more stuff :)
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
-- more stuff :)
);
CREATE TABLE agents (
agent_id integer PRIMARY KEY,name text,
country text NOT NULL,
region text,
city text,
subcity text,
when_created timestamp without time zone NOT NULL
-- more stuff :)
);
CREATE TABLE agent_transactions (
atx_id integer PRIMARY KEY,
u_id integer NOT NULL,
agent_id integer NOT NULL,
amount numeric NOT NULL,
fee_amount_scalar numeric NOT NULL,
when_created timestamp without time zone NOT NULL
-- more stuff :)
);
CREATE TABLE wallets (
wallet_id integer PRIMARY KEY,
currency text NOT NULL,
ledger_location text NOT NULL,
when_created timestamp without time zone NOT NULL
-- more stuff :)
);

5. Queries in the code  session were initiated to answer the underlisted questions

 
 1. How many users does Wave have?
2. How many transfers have been sent in the currency CFA? A transfer in Wave is when a
user (denoted by their user id in the u_id column) sends money from their Wave account
(often to another Wave user, but the recipient might also be a mobile number that hasn’t
signed up for an account yet, or the sender of the transfer could be making a bill
payment, or a few other possibilities; the `kind` column stores which possibility).
3. How many different users have sent a transfer in CFA?
4. How many agent_transactions did we have in the months of 2018 (broken down by
month)? An agent transaction (often abbreviated atx) is when someone deposits or
withdraws money from a Wave agent, and an agent is a person or business that is
contracted to facilitate transactions for users. The most important of these are cash-in
and cash-out (i.e. loading value into the mobile money system, and then converting it
back out again). A typical example: a Wave user deposits some cash into their Wave
account with their local agent (an agent transaction), then transfers that money to
another Wave user, who in turn withdraws it via another agent transaction at their own
local agent.
5. Over the course of the last week, how many Wave agents were “net depositors” vs. “net
withdrawers”? A net depositor is an agent who received more deposit volume than
withdrawal volume over some given time frame (and vice versa for a net withdrawer).
Whether an agent transaction is a deposit or a withdrawal is determined by the sign of its
amount: a ​negative ​ amount is a deposit, and a ​positive ​ amount is a withdrawal; zero
amounts aren’t allowed.
6. Build an “atx volume city summary” table: find the volume of agent transactions created
in the last week, grouped by city. You can determine the city where the agent transaction
took place from the agent’s city field.
7. Now separate the atx volume by country as well (so your columns should be country,
city, volume).
8. Build a “send volume by country and kind” table: find the total volume of transfers (by
send_amount_scalar) sent in the past week, grouped by country and transfer kind. There
are a few different kinds of Wave transfers, e.g. a ‘P2P’ transfer between a Wave user
and a mobile number, or a payment from a Wave user to a merchant. The country a
transfer was sent from isn’t stored on the transfers table itself, but rather on the wallettable’s ledger_location field (and each transfer has a source_wallet_id). Your columns
should be country, transfer kind, and volume.
9. Then add columns for transaction count and number of unique senders (still broken
down by country and transfer kind).
10. Finally, which wallets have sent more than 10,000,000 CFA in transfers in the last month
(as identified by the source_wallet_id column on the transfers table), and how much did
they send?
