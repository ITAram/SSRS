DECLARE @p_SubscriptionId UNIQUEIDENTIFIER
SET @p_SubscriptionId= '4B1ED404-63CD-4A6B-ACA4-6CC415E7F840'


EXEC [ReportServer].dbo.AddEvent @EventType='TimedSubscription', @EventData=@p_SubscriptionId 

SELECT SubscriptionID, * FROM ReportServer.dbo.vwSchduleInfo
WHERE ReportName LIKE '%trend%'

EXEC [ReportServer].dbo.AddEvent @EventType='TimedSubscription', @EventData='B5419978-B335-4103-974C-7199ECAF0765' 


SELECT * FROM ReportServerTempDB.dbo.ExecutionCache EC

DELETE ReportServerTempDB.dbo.ExecutionCache
WHERE ReportID IN 
(SELECT EC.ReportID
FROM ReportServer.dbo.Catalog C
INNER JOIN ReportServerTempDB.dbo.ExecutionCache EC ON EC.ReportID = C.ItemID
WHERE Name LIKE 'NewAccountsTrends(SALES-16)%'
	OR
	Name IN 
	(SELECT ReportName FROM ReportServer.dbo.vwSchduleInfo
		WHERE SubscriptionID = 'B5419978-B335-4103-974C-7199ECAF0765' )
)


EXEC [ReportServer].dbo.AddEvent @EventType='TimedSubscription', @EventData='B5419978-B335-4103-974C-7199ECAF0765' 