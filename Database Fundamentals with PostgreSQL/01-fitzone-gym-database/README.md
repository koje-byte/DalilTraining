# FitZone Gym Management System

A relational database project developed as part of the **Dalil Jordan Full Stack Development Training Program**.

The project focuses on database fundamentals using **PostgreSQL**, including database design, normalization, DDL, DML, DCL, joins, aggregation, subqueries, and indexing.

## 📌 Project Overview

The FitZone Gym Management System is a relational database designed to manage:

- Gym members
- Trainers and trainer mentorship
- Class categories
- Gym classes
- Training sessions
- Member bookings and session ratings

The database was designed using exactly **6 tables** as required by the assignment.

## 🗃️ Database Structure

The database contains the following tables:

| Table        | Description                                                |
| ------------ | ---------------------------------------------------------- |
| `members`    | Stores gym member information and contact/address details  |
| `trainers`   | Stores trainers and their optional mentors                 |
| `categories` | Stores gym class categories                                |
| `classes`    | Stores gym classes belonging to categories                 |
| `sessions`   | Stores scheduled sessions and assigned trainers            |
| `bookings`   | Connects members with sessions and stores ratings/comments |

### Relationships

- A category can contain multiple classes.
- A class belongs to one category.
- A class can have multiple sessions.
- A session belongs to one class and one trainer.
- A trainer can have an optional mentor who is another trainer.
- Members can book multiple sessions.
- Sessions can be booked by multiple members.
- `bookings` resolves the many-to-many relationship between members and sessions.
- Ratings and comments are stored directly in `bookings`.

## 🧩 Database Concepts Practiced

### Database Design

- Entity Relationship Diagrams
- Primary Keys
- Foreign Keys
- Self-referencing Foreign Keys
- One-to-Many relationships
- Many-to-Many relationships

### Normalization

- Unnormalized data
- Data duplication
- Update anomalies
- Repeating/multi-valued data
- Normalized relational design

### PostgreSQL / SQL

- `CREATE DATABASE`
- `CREATE TABLE`
- `ALTER TABLE`
- `TRUNCATE`
- `INSERT`
- `UPDATE`
- `DELETE`
- `RETURNING`
- `SELECT`
- `WHERE`
- `ORDER BY`
- `DISTINCT`

### Constraints

- Primary Keys
- Foreign Keys
- `NOT NULL`
- `UNIQUE`
- `CHECK`
- `DEFAULT`

### Joins

- `INNER JOIN`
- `LEFT JOIN`
- Joining multiple tables
- Self joins

### Aggregation & Subqueries

- `COUNT`
- `AVG`
- `MIN`
- `MAX`
- `SUM`
- `GROUP BY`
- `HAVING`
- Subqueries
- `NOT EXISTS`

### Database Security

- Database users
- Read-only permissions
- `GRANT`
- `REVOKE`

### Indexing

- Creating indexes
- Indexing columns used for searching
- Indexing foreign key columns
- Dropping indexes

## 📁 Project Files

- `fitzone_assignment.sql` — Complete SQL solution containing the database schema, data, queries, permissions, and indexes.
- `fitzone-schema.png` — Entity Relationship Diagram / database schema.
- `unnormalized-table-analysis.pdf` — Analysis of the initial unnormalized database design and normalization issues.

## 🎯 Assignment Requirements

The database was required to contain exactly six tables:

1. `members`
2. `trainers`
3. `categories`
4. `classes`
5. `sessions`
6. `bookings`

The project also required realistic sample data, SQL queries, database permissions, joins, aggregation queries, subqueries, and indexes.

## 🛠️ Technologies

- PostgreSQL
- SQL
- ERDPlus

## 📚 Training Program

This project was completed as part of the **Dalil Jordan Full Stack Development Training Program**.

**Course:** PostgreSQL Database
**Project:** FitZone Gym Management System
