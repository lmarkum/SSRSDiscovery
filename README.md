# SSRSDiscovery
Queries designed to determine SSRS usage.

This repo contains T-SQL queries ran via PowerShell using the DBATools module.

The query results are output to text files. 

These results are meant to allow a person to investigate usage of SSRS to see which people or service accounts are actively using SSRS.
This can be useful to know and understand as part of migration work to a newer version of SQL Server.

Please note that after SQL Server 2022, SSRS licensing was converted to PowerBI licensing. This means that there is no SSRS for SQL Server 2025 and later.

Please also see this link as inspiration and other source material for reviewing SSRS:
https://www.red-gate.com/simple-talk/databases/sql-server/bi-sql-server/insights-from-the-ssrs-database/ 


Requirements and Dependencies:
1. The necessary SQL Server access to query the ReportServer database.
2. The DBATools module.
3. Please fill in the SQLInstance value before running.
4. Note that there is a stub CASE statement that will also need to be filled in if the query needs to convert AD accounts to people's names. Or, the CASE can be commented out if this is not desired or needed.

