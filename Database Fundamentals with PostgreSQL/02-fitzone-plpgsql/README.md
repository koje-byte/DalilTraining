# FitZone Gym Management System — PL/pgSQL

This project is the second PostgreSQL assignment completed as part of the **Dalil Jordan Full Stack Development Training Program**.

It is a continuation of the **FitZone Gym Management System** database developed in the previous assignment.

## 📌 Project Overview

This assignment focuses on **PL/pgSQL programming** and builds on the existing `fitzone_db` database.

The original six core tables remain unchanged:

- `members`
- `trainers`
- `categories`
- `classes`
- `sessions`
- `bookings`

The assignment applies procedural programming and database automation directly to the existing FitZone data.

## 🧠 Concepts Practiced

### PL/pgSQL Fundamentals

- Anonymous `DO` blocks
- Variables
- `%TYPE`
- `SELECT INTO`
- `RAISE NOTICE`
- `IF / ELSIF / ELSE`
- `FOR` loops
- `WHILE` loops
- `RECORD` variables

### Functions

- Returning scalar values
- Returning table rows
- Function parameters
- `RETURNS TEXT`
- `RETURNS NUMERIC`
- `RETURNS INT`
- `RETURNS BOOLEAN`
- Functions for business logic

### Procedures

- Adding bookings
- Updating member status
- Procedures with parameters
- Error handling

### Error Handling

- `BEGIN / EXCEPTION / END`
- `unique_violation`
- `foreign_key_violation`
- Friendly error messages using `RAISE NOTICE`

### Triggers

- Validation triggers
- Business rule triggers
- Preventing duplicate/invalid operations
- Preventing multiple rating updates
- Automatic loyalty level updates

### Audit Logging

- `audit_log` table
- Logging `INSERT`, `UPDATE`, and `DELETE` operations
- Trigger functions

### Business Logic

- Loyalty points
- Loyalty level
- Rating validation
- Available session seats
- Member and trainer lookups

## 📁 Project Files

- `fitzone_plpgsql_assignment.sql` — Complete PL/pgSQL solution containing all required blocks, functions, procedures, exception handling, triggers, and sample calls.

## 🔗 Related Project

This assignment continues the database created in:

**[01 — FitZone Gym Database](../01-fitzone-gym-database/)**

The original database design and data are reused for this assignment.

## 🛠️ Technologies

- PostgreSQL
- PL/pgSQL
- SQL

## 🎯 Learning Objective

The purpose of this assignment was to move beyond basic SQL queries and learn how to implement **procedural logic, reusable functions, error handling, automation, triggers, and database-level business rules** using PostgreSQL.
