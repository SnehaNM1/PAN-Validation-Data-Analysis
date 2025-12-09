PAN Number Validation Project

This project performs data cleaning and validation on a dataset containing Indian PAN (Permanent Account Number) values.
The goal is to ensure that each PAN follows the official government format and to classify each entry as Valid or Invalid.

🔍 Objectives

Clean the dataset (remove spaces, fix letter case, handle missing values).

Remove duplicate PAN entries.

Validate PAN format based on official rules.

Categorize each PAN as VALID, INVALID, or MISSING.

Generate a summary report.

📌 PAN Validation Rules

A valid PAN:

Is exactly 10 characters long.

Follows the format: AAAAA9999A

First 5 characters → Uppercase letters (A–Z)

Next 4 characters → Digits (0–9)

Last character → Uppercase letter

Additional logic:

No adjacent duplicate letters in the first 5 (e.g., AABCD ❌).

No sequential letters (ABCDE, BCDEF ❌).

No adjacent duplicate digits in the next 4 (e.g., 1123 ❌).

No sequential digits (1234, 2345 ❌).

🛠️ Tools Used

You can complete the project using either:

SQL (PostgreSQL + PL/pgSQL)

Python (pandas)

Both implementations are included.
