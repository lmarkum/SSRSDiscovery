Set-DbatoolsInsecureConnection -SessionOnly
$SQLInstance = ''
$Database = 'ReportServer'

<#
Return from the view ExecutionLog2 the distinct reports and the last time they ran
#>
Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query "SELECT DISTINCT ReportPath, CAST(TimeStart AS DATE) AS TimeStartDate
FROM dbo.ExecutionLog2
ORDER BY CAST(TimeStart AS DATE) DESC;" | Out-File -FilePath 'C:\temp\SSRSReportExecutionByDate_ExecutionLog2.txt'


<#
Identify unique users for reports from the view ExecutionLog2.
#>
Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query "SELECT DISTINCT(UserName) FROM dbo.ExecutionLog2;" | Out-File 'C:\temp\SSRSReportsUsersNames_ExecutionLog2.txt'


<#
Return the most recent report each person ran
#>


Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query "SELECT CASE WHEN UserName ='' THEN '' 

ELSE UserName END AS [UserName], 

ReportPath,
MAX(TimeStart) AS MostRecentReportRun
FROM dbo.ExecutionLog2 AS EL2
GROUP BY UserName, ReportPath
ORDER BY MAX(TimeStart) DESC;" | Out-File 'C:\temp\SSRSReportsMostRecentReportsRanByUserName_ExecutionLog2.txt'


<#
Return from the view ExecutionLog2 the usernames and the recent reports they ran.
#>

Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query "
--Distinct Users who have ran a report recently
SELECT DISTINCT EL2.UserName, 
CASE 
WHEN EL2.UserName ='' 
THEN '' 
ELSE EL2.UserName END AS [UserName], 
ReportPath

FROM dbo.ExecutionLog2 AS EL2
WHERE EL2.UserName <> 'SRB\111310'
ORDER BY EL2.UserName, ReportPath;" | Out-File 'C:\temp\SSRSReportsUserNamesAndReportsRan_ExecutionLog2.txt' 


<#
Return subscription information 
#>
Invoke-DbaQuery -SqlInstance $SQLInstance -Database $Database -Query "SELECT
	ReportSchedule.ScheduleID AS AgentJobName,
	Subscriptions.Description,
	Subscriptions.LastStatus,
	Subscriptions.EventType,
	Subscriptions.LastRunTime,
	Subscriptions.Parameters,
	SUBSCRIPTION_OWNER.UserName, 
        Catalog.Name AS ReportName,
	MODIFIED_BY.UserName AS LastModifiedBy,
	Subscriptions.ModifiedDate
FROM dbo.Subscriptions
INNER JOIN dbo.Users SUBSCRIPTION_OWNER
ON SUBSCRIPTION_OWNER.UserID = Subscriptions.OwnerID
INNER JOIN dbo.Catalog
ON Catalog.ItemID = Subscriptions.Report_OID
INNER JOIN dbo.Users MODIFIED_BY
ON MODIFIED_BY.UserID = Subscriptions.ModifiedByID
INNER JOIN dbo.ReportSchedule
ON ReportSchedule.SubscriptionID = Subscriptions.SubscriptionID
AND ReportSchedule.ReportID = Catalog.ItemID;;" | Out-File 'C:\temp\SSRSReportsSubscriptions.txt'






