---
title: "Gaming Platform Database IM-CW1 Report"
author: "2242090"
bibliography: report/references.bib
toc: true
toc-title: Table of Contents
toc-depth: 3
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

## 2.1 Player dashboard

## 2.2 Support tickets

## 2.3 Manager dashboard

## 2.4 Payment history

## 2.5 Game catalog

## 2.6 Approve transactions

## 2.7 Purchase games

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

### 3.2.2 Accounts schema

```sql
CREATE SCHEMA AccountSchema;
```

#### 3.2.2.1 PlayerAccounts

```sql
CREATE TABLE IF NOT EXISTS AccountSchema.PlayerAccounts (
    PlayerAccountID SERIAL PRIMARY KEY,
    PlayerID SERIAL,
    Balance DECIMAL(10, 2) DEFAULT 0.00
);
```

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

## 3.3 Entity relationships

## 3.4 Roles and permissions

## 3.5 Views

## 3.6 Functions and procedures

# 4 GDPR compliance

# 5 Appendices

## 5.1 Link to GitHub repository

[Gaming Platform Database Backend (im-cw1)](https://github.com/iArcanic/im-cw1)

# 6 References
