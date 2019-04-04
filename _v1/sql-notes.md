---
layout: compsci-note
title: SQL Notes
categories: [database]
description: Some notes on SQL queries
order: 20
sitemap: false
---

# Basics

## Case statements

```sql
SELECT
  CASE WHEN <condition 1> THEN <a1> WHEN <condition 2> THEN <a2> ELSE <a3> END,
  CASE WHEN <condition 1> THEN <b1> WHEN <condition 2> THEN <b2> ELSE <b3> END,
  col3 = CASE WHEN col2 = 0 THEN 'no' ELSE 'yes' END
FROM
  <table>
```

## Alter tables

```sql
-- Creating foreign keys
ALTER TABLE dbo.foreign_table
ADD CONSTRAINT FK_name FOREIGN KEY (primary_col)
REFERENCES dbo.primary_table (primary_col)

-- Changing a column type etc.
ALTER TABLE client_devices
ALTER COLUMN apMacAddr VARCHAR(255) NULL

-- Creating unclustered Index
CREATE INDEX UC_col_index ON dbo.table_name (col4 ASC)
INCLUDE (col1, col2, col3)

```