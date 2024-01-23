---
title: "Gaming Platform Database IM-CW1 Report"
author: "2242090"
bibliography: report/references.bib
toc: true
toc-title: Table of Contents
toc-depth: 3
geometry: "left=1.25cm, right=1.25cm, top=1.25cm, bottom=1.25cm"
csl: report/harvard-imperial-college-london.csl
---

# 1 Introduction

This report documents the design and relevant implementation details of a GDPR-complaint database system regarding an online gaming platform. The system has the following purposes managing the registration of players and their accounts, handling transactions, and integrating assistance measures via employees or managers.

It is important to define the scope of this project and not deviate in the development phase. The focus is solely on the back-end database design and the relevant complaint features when it comes to data protection laws. Elements such as front-end UI optimisation or other customer-facing aspects are therefore out of this scope.

The following sections of this report provide a typical user journey workflow, the entity relationship design diagram, and its counterpart implementation in code (i.e. SQL), any unfinished features, and appropriate recommendations. This is necessary for evaluating how GDPR requirements have been addressed.

## 1.2 Project deliverables

Key deliverables from this project include:

- A normalised PostgreSQL database, with necessary tables, roles, views, functions, and procedures.
- An executable SQL script containing all the statements needed to meet organisation requirements.
- An entity relationship diagram to visually detail the relationships between entities.
- A configuration folder with security access controls when launching the database.

# 2 User journeys

The online gaming platform facilitates a variety of features and interactions between players, games, and administrators. Along with this, comes the assumption of key workflows to streamline to sandbox a certain functionality – readily and easily executed when needed. This section outlines the high-level user journeys that the various user groups take to accomplish their objectives within the system.

All user journeys are implemented using PostgreSQL views, functions, and procedures (which are also included). The advantage of this is that a combination of SQL statements can be modularised and run as a collection, rather than manual execution one by one.

Note that this does not mean any UI implementation, as mentioned in [1 Introduction](#1-introduction). Only the relevant business logic is considered.

## 2.1 Player dashboard

The player dashboard provides an overarching interface where they can view information about their account. Upon logging in, they can see their corresponding player ID, their selected username, and the balance of both their game and in-game accounts.

The supporting view for this is as follows:

```sql
CREATE VIEW PlayerSchema.PlayerDashboard AS
SELECT P.PlayerID, P.Username, PA.Balance AS MainAccountBalance
FROM PlayerSchema.Players P
    JOIN AccountSchema.PlayerAccounts PA ON P.PlayerID = PA.PlayerID;
```

## 2.2 Manager dashboard

The manager dashboard, similar to the player dashboard, provides business-specific analytics and useful performance statistics across aspects of the gaming platform. It means that managers or any administrative roles can make well-informed data-driven decisions that may commercially impact the business. Such information present on the dashboard includes information on all players – their account details and game/in-game balances.

The supporting view for this is as follows:

```sql
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
```

## 2.3 Payment history

This functionality enables players to view and reconcile all financial transactions relating to their game and in-game accounts. Since there are different types of transactions with different currencies, the movement of that money creates an auditable trail that should be captured. This financial activity display will consist of the transaction's timestamp, amount, approval status, the game, and the player it concerns.

The supporting view for this is as follows:

```sql
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
```

## 2.4 Game catalog

The game catalog showcases the portfolio of all available game titles on the platform that the company advertises. It serves as both a marketing platform as well as players browsing for new games to play. Details about the game, its title, genre, and release date will give players clear expectations. Furthermore, players can rank games by their rating and/or popularity.

The supporting view for this is as follows:

```sql
CREATE VIEW GameSchema.GameCatalog AS
SELECT GameID, Title, Genre, ReleaseDate
FROM GameSchema.Games;
```

## 2.5 Approve transactions

This is mainly for managers to review and authorise privileged transactions on the gaming platform. Requiring manager approval before allowing transfers over secure communications is vital for a streamlined gaming platform and provides an additional point of control. This will set the transaction's status in transit to be set to "Approved" status and signed off by the relevant employee – who must be a manager of course.

The supporting function for this is as follows:

```sql
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
```

## 2.6 Purchase games

This user journey is the core monetisation point of the platform, allowing players to select a specific game from the Game Catalog for example. Once a player decides which game they would like to purchase, it appropriately debits and updates their balance, whilst also making a new transaction record. Upon buying and downloading, post-processing actions may be distributing the required license keys or download links. A payment receipt is also returned to the user with the right details.

The supporting procedure for this is as follows:

```sql
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
```

# 3 Data model implementation

## 3.1 Entity-Relationship Diagram (ERD)

The data model was designed using an Entity-Relationship Diagram (ERD) approach, which helps to represent the key entities and define the relationships between them.

See Appendix []() for the ERD.

## 3.2 Entities

The core entities identified for this scenario are separated into distinct categories called schema. Each schema is a collection of these database entities. It helps to assign specific roles to a certain schema, visually clarify the purpose and belonging of entities, and can be managed much more easily.

### 3.2.1 Player schema

```sql
CREATE SCHEMA PlayerSchema;
```

This database schema is dedicated to holding user-entity tables, such as `Players` in this instance. The main aim is to segregate personal data, which may be sensitive and cannot traverse across a span of tables or be accessed by unathorised roles. Allows for easier management of access controls and security policies due to there being only a singular table, and thus, more readily abide by GDPR laws.

#### 3.2.2.1 Players

```sql
CREATE TABLE IF NOT EXISTS PlayerSchema.Players (
    PlayerID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Fullname VARCHAR(255) NOT NULL,
    DateOfBirth DATE, Address TEXT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

The `Players` table stores personal information about their users, which is categorised as sensitive. The `Password` attribute will undoubtedly be hashed with a robust cryptographic function. `Fullname` can serve as a secondary index to quickly search players. `DateOfBirth` can serve as a restriction when purchasing games with an "18+" age rating for example. Finally, `Email`` is how the online gaming platform contacts the user and is the primary source of contact.

### 3.2.2 Accounts schema

```sql
CREATE SCHEMA AccountSchema;
```

The purpose of this schema is to hold tables relating to accounts, being an internal ledger and allowing the tracking of funds for purchasing games and also purchases for using in-game funds – it always has the Player's most up-to-date balance. Since personal data is segregated, these tables only store the minimal information required, and therefore, role permissions can be more specific.

#### 3.2.2.1 PlayerAccounts

```sql
CREATE TABLE IF NOT EXISTS AccountSchema.PlayerAccounts (
    PlayerAccountID SERIAL PRIMARY KEY,
    PlayerID SERIAL,
    Balance DECIMAL(10, 2) DEFAULT 0.00
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

The `PlayerAccounts` table is mainly for purchases of the actual games advertised by the online gaming platform itself. Obviously, it takes a unique ID as `PlayerAccountID`, but more importantly, a foreign key relationship to the `PlayerSchema.Players` table – linking the `Player` entity. This means that registered accounts will have a relationship with the player and thus can access their personal data (only permitted attributes) if necessary. Next, the `Balance` attribute always stores the most updated value, with a default of 0 on creation. Finally, the `UpdatedDate` field is a timestamp record of when the balance was updated.

#### 3.2.2.2 InGamePlayerAccounts

```sql
CREATE TABLE IF NOT EXISTS AccountSchema.InGamePlayerAccounts (
    InGamePlayerAccountID SERIAL PRIMARY KEY,
    PlayerID SERIAL,
    GameID SERIAL,
    Balance DECIMAL(10, 2) DEFAULT 0.00,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

This table is when the player makes an account specific only to that game. As seen in the above SQL statements, a unique ID `InGamePlayerAccountID` is required. As previously, it has a foreign key relationship with the `Player` if access to the player's information is needed. It also has a foreign key relationship to the specific game via `GameID` as it needs to store a `Balance` of that game's currency. Finally, the last attribute `UpdatedDate`, takes the current timestamp of when the `Balance` was updated.

### 3.2.3 GameSchema

```sql
CREATE SCHEMA GameSchema;
```

The `GameSchema`, similar to the `PlayerSchema`, only has one table and this is beneficial in assigning only the relevant permissions required. Any game-related tables are under this schema, making it only more scalable in the future, if the company decides to incorporate more game-specific features. This means that other schemas are not affected and disturbed – the roles, permissions, and relationships remain the same regardless.

#### 3.2.3.1 Games

```sql
CREATE TABLE IF NOT EXISTS GameSchema.Games (
    GameID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Rating VARCHAR(10),
    Genre VARCHAR(50),
    Publisher VARCHAR(255),
    ReleaseDate DATE
);
```

Like the `Player` entity, the `Game` is also a master table since it has no foreign key relations. A unique ID of `GameID` differentiates each `Game`. A `Title` by which the game is referenced, and can even serve as a secondary index for fast searching. The `Rating`, `Genre`, and `ReleaseDate` properties are fields by which the user can filter for games easily (see [2.4 Game catalog](#24-game-catalog)).

### 3.2.4 EmployeeSchema

```sql
CREATE SCHEMA EmployeeSchema;
```

This schema constitutes all tables relating to the `Employee` entity, the relevant functionality, and user journeys. Like `Player`, this schema represents another user environment, which also means that personal data associated with them is sandboxed. If additional departments with different purposes are added if the company grows, they can easily be appended to this schema, with different roles and permissions being granted.

#### 3.2.4.1 Employees

```sql
CREATE TABLE IF NOT EXISTS EmployeeSchema.Employees (
    EmployeeID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Fullname VARCHAR(255) NOT NULL,
    EmployeeRole EmployeeRole NOT NULL
);
```

Again, like `Player` and `Game`, this is also another master table within the database. As always, a unique ID, `EmployeeID` is taken as the primary key. Additional pieces of sensitive data, i.e. `Username` and `Fullname` give this entity some depth and body.

```sql
CREATE TYPE EmployeeRole AS ENUM('Employee', 'Manager');
```

Finally, the `EmployeeRole` field takes on the `EmployeeRole` type, which is an enumeration. It means that this field has to confirm the values specified here only, i.e. a `Manager` or a regular `Employee`.

#### 3.2.4.2 PlayerSupport

```sql
CREATE TABLE IF NOT EXISTS EmployeeSchema.PlayerSupport (
    PlayerSupportID SERIAL PRIMARY KEY,
    EmployeeID SERIAL,
    PlayerID SERIAL,
    Notes TEXT,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

This table is akin to a support ticket system, storing details about any players being assisted. The ID as always, `PlayerSupportID`. Two foreign key references to previous tables, linking the `Employee` and `Player`. The `Notes` attribute serves as a description, detailing information about the issue and how it was resolved. Like with tables in `AccountSchema`, an `UpdatedDate` attribute takes the default locale timestamp of when the support ticket was addressed.

### 3.2.5 TransactionsSchema

The `TransactionsSchema` consists of all payment-related tables. This schema has to be secure since handling payments has sensitive information, even if it isn't explicitly attributed to that entity – they can be inferred from the foreign key relations.

#### 3.2.5.1 GameTransactions

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactions (
    GameTransactionID SERIAL PRIMARY KEY,
    PlayerAccountID SERIAL,
    GameID SERIAL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Similar with the logic in differentiating game and in-game entities, `GameTransaction` is the record of all game purchases with real-life money only. After the unique ID of `GameTransactionID`, two foreign key references are made. One referencing the correlating `PlayerAccountID`, i.e. the player who initiated the transaction with their purchase in the first place. The other, `GameID`, links the game that the player wants to purchase. The `Amount` attribute, of course, is the cost being transferred. And last but not least, the `TransactionDate` takes the current timestamp of when this record was committed.

#### 3.2.5.2 InGameTransactions

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactions (
    InGameTransactionID SERIAL PRIMARY KEY,
    InGamePlayerAccountID SERIAL,
    GameID SERIAL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Similar to the previous transaction entity (see [3.2.5.1 GameTransactions](#3251-gametransactions)) except for purchases made using the in-game built-in currency. This time, instead, it takes a foreign key relation to the player's in-game account to use that balance, rather than the `PlayerAccount`.

#### 3.2.5.3 GameTransactionApprovals

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactionApprovals (
    GameTransactionApprovalID SERIAL PRIMARY KEY,
    GameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL DEFAULT 'Pending',
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Here, this table consists of the approval for transactions for the games only, made with real-life money of course. Foreign key relations are defined, linking the correct `GameTransaction` that needs approval, the assigned `Employee` (a `Manager`), and the date timestamp. it was approved, via `UpdatedDate`.

```sql
CREATE TYPE ApprovalStatus AS ENUM(
    'Pending', 'Approved', 'Rejected'
);
```

An enumeration is created for the `ApprovalStatus`, meaning that it can only take one of the three above states. Only a `Manager` can alter the transaction state, and if so, it has to conform to these three values, with a default state of "Pending" if not yet approved by a `Manager`.

#### 3.2.5.4 InGameTransactionApprovals

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactionApprovals (
    InGameTransactionApprovalID SERIAL PRIMARY KEY,
    InGameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL DEFAULT 'Pending',
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Again, similar to `GameTransactionApprovals` (see [3.2.5.3 GameTransactionApprovals](#3253-gametransactionapprovals)), but the in-game counterpart. Here instead, a reference to the `InGameTransaction` is made, relating the correct transaction that was made with the game's currency.

### 3.2.6 ESportsSchema

```sql
CREATE SCHEMA ESportsSchema;
```

Although this schema is not vital to the regular functioning of the online gaming system, it serves more as a proof of concept demonstrating the scalability of such a database design. The schema is to do with the more competitive side that the gaming platform may want to feature along with the many games that they have. This takes inspiration from real e-sports tournaments, the way that they are structures, and the way that they are conducted.

#### 3.2.6.1 Tournaments

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.Tournament (
    TournamentID SERIAL PRIMARY KEY,
    GameID SERIAL,
    TournamentName VARCHAR(255) NOT NULL,
    StartDate TIMESTAMP,
    EndDate TIMESTAMP
);
```

A master table of this schema, holding `Tournament` entities. Since tournaments are based on a singular game, it needs a reference to that specific game, so a foreign key reference, `GameID`, is made. The tournament needs a descriptive name, so hence the attribute `TournamentName`. A duration is taken, and is defined by the `StartDate` and `EndDate`. Note that these do not take the `DATE` data type but rather a `TIMESTAMP` instead, since e-sports tournaments are very strict on rules regarding timeliness.

#### 3.2.6.2 Teams

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.Teams (
    TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(255) NOT NULL
);
```

Typically, in e-sport tournaments, players compete in pre-determined teams. Therefore, this master table represents just that. A unique ID of `TeamID` is taken, along with a name the team might have for themselves in `TeamName`.

#### 3.2.6.3 TeamPlayers

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.TeamPlayers (
    TeamPlayerID SERIAL PRIMARY KEY,
    TeamID SERIAL,
    PlayerID SERIAL
);
```

Since teams are comprised of a collection of players, a separate entity, `TeamPlayers`, needs to define this separately – not just use the `PlayerEntity` on its own. Rather, after the primary key `TeamPlayerID` has been assigned, it takes foreign relations of `TeamID` and `PlayerID`. The former representing the team to which the player belongs too, and the later referencing the actual `Player` object.

#### 3.2.6.4 TournamentResults

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.TournamentResults (
    TournamentResultID SERIAL PRIMARY KEY,
    TournamentID SERIAL,
    TeamID SERIAL,
    TournamentResultStatus TournamentResultStatus NOT NULL
);
```

After a tournament has finished, a results table needs to be compiled containing details of each team's performance. This means the correct `Tournament` has to be linked to this record as a foreign key specifically, along with the team competed via the `TournamentID` and `TeamID` respectively.

```sql
CREATE TYPE TournamentResultStatus AS ENUM(
 'First', 'Second', 'Third', 'Discontinued'
);
```

As before, here is an enumeration for each teams result status. Currently, it has been set to these four values – which the attribute in the table has to conform to, however, this can easily be scalable. More result parameters can be added as and when required, such as more finishing positions or a Prize enumeration.

## 3.5 Roles and permissions

Each `GRANT` statement only allows a narrow scope of privileges fitting the context of the entity. This supports the idea of the least privilege principle, allowing for a more secure database and limiting unathorised access. This mapping in the backend can give a good approximation in how that specific entity will legally interact with the system, allowing for a good balance in usability and data protection.

### 3.5.1 PlayerRole

```sql
CREATE ROLE PlayerRole;
```

The `PlayerRole` role represents authenticated end-users of the online gaming platform, i.e. those who have registered profiles and carry out typical system actions, such as interacting with offered game titles, purchasing games, and so on.

```sql
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA PlayerSchema TO PlayerRole;
```

Here, the `PlayerRole` has access to the `PlayerSchema` which contains the `Player` entity. To comply with GDPR the following SQL statements allow the player view and edit their own personal information.

```sql
GRANT SELECT ON ALL TABLES
IN SCHEMA GameSchema TO PlayerRole;
```

Here however, only the `SELECT` command is given for this schema. It makes sense for Players to be unable to modify available games and details (restricted to Managers (see [3.5.3 `ManagerRole`](#353-managerrole))), but only to view the game catalog to purchase titles.

```sql
GRANT SELECT ON ALL TABLES
IN SCHEMA ESportsSchema TO PlayerRole;
```

Similarly, Players are only allowed to view any `Tournaments`, `Teams`, and the respective `TeamPlayers` and not edit details – which is for Managers to do so (see [3.5.3 `ManagerRole`](#353-managerrole)).

### 3.5.2 EmployeeRole

```sql
CREATE ROLE EmployeeRole;
```

This represents all least privileged personnel who run the gaming platform that run various business support operations, such as player assistance, player account management, security audits, and payment administration. They have a wider scope of privileges, but still restricted (they are not the most privileged role).

```sql
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA EmployeeSchema TO EmployeeRole;
```

Full CRUD access is given to `Employees`, like players, to manage their own personal data in order to be compliant with GDPR laws. This is supported by the following SQL statements, like `SELECT`, `INSERT`, and `UPDATE` as this is their own entity master table.

```sql
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA PlayerSchema TO EmployeeRole;
```

Employees are also given full access to the `PlayerSchema` table, since the employees assist players with any issues. This also means that they need access to the player's data so they can use usage trends and metric for company improvements.

```sql
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA AccountSchema TO EmployeeRole;
```

Again, employees are given access to player accounts for providing support in financial workflows like resolving disputes or general payment enquiries. The `INSERT` and `UPDATE` command is enabled for providing refunds or bonuses for example.

```sql
GRANT SELECT, INSERT ON ALL TABLES
IN SCHEMA TransactionSchema TO EmployeeRole;
```

For the `TransactionSchema`, the `SELECT` and `INSERT` role is only granted – for auditing reasons. This is to trace failed or fraudulent transactions and update their status accordingly.

```sql
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA ESportsSchema TO EmployeeRole;
```

This allows the employees to conduct the appropriate processing operations and visibility into tournaments statistics and using the event data to improve esports in the future. Any improvements that are made require commands such as `INSERT` and `UPDATE`, since employees are the tournament admins and overseers.

### 3.5.3 ManagerRole

```sql
CREATE ROLE ManagerRole;
```

As alluded to from before, the `ManagerRole` is the most privileged role within the online gaming platform infrastructure. These are akin to executives who govern the major areas of the platform's business operations and conduct a relevant strategy. Since this is the case, the highest level of privilege means complete visibility and control as per their responsibilities.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PlayerSchema TO ManagerRole;
```

The `Manager` role is granted full access to customer data, player profiles, activity, transaction history, and support tickets. This data is therefore key in understanding user behavior and as such, optimise the gaming platform.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA AccountSchema TO ManagerRole;
```

This allows for complete visibility into all financial data, balances across different games to spot revenue patterns for potentially optimising what game titles are advertised.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA GameSchema TO ManagerRole;
```

Any new games that the platform decides to implement will only be updated by the manager. Furthermore, game trends and metrics can help with monetisation strategies – for choosing future game titles.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA TransactionSchema TO ManagerRole;
```

Allows investigation of trends into fraudulent or suspicious payments and allows for risk analysis. Securing payment integrity is vital since sensitive information and money is being moved.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA EmployeeSchema TO ManagerRole;
```

Managers also have the ability to manage employees working under them, so visibility is required into the team members, productivity metrics, what roles employees have, and permissions that may need updating in the long-term.

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ESportsSchema TO ManagerRole;
```

Tournaments need to be conducted by administrators, i.e. managers, so they need to be able to have insight into registration trends, event data, and prize pools to allow for more engagement.

# 5 Appendices

## 5.1 GitHub repository

[Gaming Platform Database Backend (im-cw1)](https://github.com/iArcanic/im-cw1)

# 6 References
