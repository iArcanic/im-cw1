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

#### 3.2.2.1 Players

### 3.2.2 Accounts schema

#### 3.2.2.1 PlayerAccounts

#### 3.2.2.2 InGamePlayerAccounts

### 3.2.3 GameSchema

#### 3.2.3.1 Games

### 3.2.4 EmployeeSchema

#### 3.2.4.1 Employees

#### 3.2.4.2 PlayerSupport

### 3.2.5 TransactionsSchema

#### 3.2.5.1 GameTransactions

#### 3.2.5.2 InGameTransactions

#### 3.2.5.3 TransactionApprovals

### 3.2.6 ESportsSchema

#### 3.2.6.1 Tournaments

#### 3.2.6.2 Teams

#### 3.2.6.3 TeamPlayers

#### 3.2.6.4 MatchResults

## 3.3 Entity relationships

## 3.4 Roles and permissions

## 3.5 Views

## 3.6 Functions and procedures

# 4 GDPR compliance

# 5 Appendices

## 5.1 Link to GitHub repository

[Gaming Platform Database Backend (im-cw1)](https://github.com/iArcanic/im-cw1)

# 6 References
