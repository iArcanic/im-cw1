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

All user journeys are implemented using PostgreSQL views, functions, and procedures. The advantage of this is that a combination of SQL statements can be modularised and run as a collection, rather than manual execution one by one.

Note that this does not mean any UI implementation, as mentioned in [1 Introduction](#1-introduction). Only the relevant business logic is considered.

## 2.1 Player dashboard

The player dashboard provides an overarching interface where they can view information about their account. Upon logging in, they can see their corresponding player ID, their selected username, and the balance of both their game and in-game accounts.

See []() for details on implementation.

## 2.2 Manager dashboard

The manager dashboard, similar to the player dashboard, provides business-specific analytics and useful performance statistics across aspects of the gaming platform. It means that managers or any administrative roles can make well-informed data-driven decisions that may commercially impact the business. Such information present on the dashboard includes information on all players – their account details and game/in-game balances.

See []() for details on implementation.

## 2.3 Payment history

This functionality enables players to view and reconcile all financial transactions relating to their game and in-game accounts. Since there are different types of transactions with different currencies, the movement of that money creates an auditable trail that should be captured. This financial activity display will consist of the transaction's timestamp, amount, approval status, the game, and the player it concerns.

See []() for details on implementation.

## 2.4 Game catalog

The game catalog showcases the portfolio of all available game titles on the platform that the company advertises. It serves as both a marketing platform as well as players browsing for new games to play. Details about the game, its title, genre, and release date will give players clear expectations. Furthermore, players can rank games by their rating and/or popularity.

See []() for details on implementation.

## 2.5 Approve transactions

This is mainly for managers to review and authorise privileged transactions on the gaming platform. Requiring manager approval before allowing transfers over secure communications is vital for a streamlined gaming platform and provides an additional point of control. This will set the transaction's status in transit to be set to "Approved" status and signed off by the relevant employee – who must be a manager of course.

See []() for details on implementation.

## 2.6 Purchase games

This user journey is the core monetisation point of the platform, allowing players to select a specific game from the Game Catalog for example. Once a player decides which game they would like to purchase, it appropriately debits and updates their balance, whilst also making a new transaction record. Upon buying and downloading, post-processing actions may be distributing the required license keys or download links. A payment receipt is also returned to the user with the right details.

See []() for details on implementation.

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
);
```

The `PlayerAccounts` table is mainly for purchases of the actual games advertised by the online gaming platform itself. Obviously, it takes a unique ID as `PlayerAccountID`, but more importantly, a foreign key relationship to the `PlayerSchema.Players` table – linking the `Player` entity. This means that registered accounts will have a relationship with the player and thus can access their personal data (only permitted attributes) if necessary. Finally, the `Balance` attribute always stores the most updated value, with a default of 0 on creation.

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

#### 3.2.3.1 Games

```sql
CREATE TABLE IF NOT EXISTS GameSchema.Games (
    GameID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Rating VARCHAR(10), Genre VARCHAR(50),
    Publisher VARCHAR(255),
    ReleaseDate DATE
);
```

### 3.2.4 EmployeeSchema

```sql
CREATE SCHEMA EmployeeSchema;
```

#### 3.2.4.1 Employees

```sql
CREATE TABLE IF NOT EXISTS EmployeeSchema.Employees (
    EmployeeID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Fullname VARCHAR(255) NOT NULL
);
```

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

### 3.2.5 TransactionsSchema

```sql
CREATE SCHEMA TransactionsSchema;
```

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

#### 3.2.5.3 GameTransactionApprovals

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.GameTransactionApprovals (
    GameTransactionApprovalID SERIAL PRIMARY KEY,
    GameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 3.2.5.4 InGameTransactionApprovals

```sql
CREATE TABLE IF NOT EXISTS TransactionSchema.InGameTransactionApprovals (
    InGameTransactionApprovalID SERIAL PRIMARY KEY,
    InGameTransactionID SERIAL,
    EmployeeID SERIAL,
    ApprovalStatus ApprovalStatus NOT NULL,
    UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3.2.6 ESportsSchema

```sql
CREATE SCHEMA ESportsSchema;
```

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

#### 3.2.6.2 Teams

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.Teams (
    TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(255) NOT NULL
);
```

#### 3.2.6.3 TeamPlayers

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.TeamPlayers (
    TeamPlayerID SERIAL PRIMARY KEY,
    TeamID SERIAL,
    PlayerID SERIAL
);
```

#### 3.2.6.4 TournamentResults

```sql
CREATE TABLE IF NOT EXISTS ESportsSchema.TournamentResults (
    TournamentResultID SERIAL PRIMARY KEY,
    TournamentID SERIAL,
    TeamID SERIAL,
    TournamentResultStatus TournamentResultStatus NOT NULL
);
```

## 3.5 Roles and permissions

## 3.6 Views

## 3.7 Functions and procedures

# 4 GDPR compliance

# 5 Appendices

## 5.1 GitHub repository

[Gaming Platform Database Backend (im-cw1)](https://github.com/iArcanic/im-cw1)

# 6 References
