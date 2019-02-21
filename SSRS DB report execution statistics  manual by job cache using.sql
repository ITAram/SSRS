SELECT *
 FROM dbo.ExecutionLog3
WHERE itempath <>'/Datasets/rsBusinessDay'
AND requesttype ='Interactive'
--AND source ='Cache'
AND Timestart>DATEADD(m,-1,GETDATE())
AND username NOT LIKE 'tor\07%' AND username NOT IN ('tor\011347','tor\011220','tor\011868') --Svetlana,Ruben,Hakob
AND Source <>'Session'
ORDER BY itempath
                                                                                                                                     
SELECT Itempath, COUNT(*) AS number_of_manual_executions, COUNT(DISTINCT username) AS Users
	, SUM(TimeDataRetrieval/60000) AS TotalExecTime_Minutes  -- itempath, COUNT(*)
 FROM dbo.ExecutionLog3
WHERE itempath <>'/Datasets/rsBusinessDay'
AND requesttype ='Interactive'
--AND source ='Cache'
AND Timestart>DATEADD(m,-1,GETDATE())
AND username NOT LIKE 'tor\07%'AND username NOT IN ('tor\011347','tor\011220') --Svetlana,Ruben
AND Source <>'Session'
GROUP BY ItemPath
ORDER BY SUM(TimeDataRetrieval/60000)  DESC --itempath, TimeStart



SELECT Itempath, CONVERT(DATE, TimeStart) AS Date,COUNT(*) AS number_of_manual_executions_during_day, COUNT(DISTINCT username) AS Users
	, SUM(TimeDataRetrieval/60000) AS TotalExecTime_Minutes  -- itempath, COUNT(*)
 FROM dbo.ExecutionLog3
WHERE itempath <>'/Datasets/rsBusinessDay'
AND requesttype ='Interactive'
--AND source ='Cache'
AND Timestart>DATEADD(m,-1,GETDATE())
AND username NOT LIKE 'tor\07%'AND username NOT IN ('tor\011347','tor\011220') --Svetlana,Ruben
AND Source <>'Session'
GROUP BY ItemPath,CONVERT(DATE, TimeStart) 
ORDER BY COUNT(*)  DESC --itempath, TimeStart



SELECT DISTINCT itempath
FROM
(SELECT Itempath, CONVERT(DATE, TimeStart) AS Date,COUNT(*) AS number_of_manual_executions_during_day, COUNT(DISTINCT username) AS Users
	, SUM(TimeDataRetrieval/60000) AS TotalExecTime_Minutes  -- itempath, COUNT(*)
 FROM dbo.ExecutionLog3
WHERE itempath <>'/Datasets/rsBusinessDay'
AND requesttype ='Interactive'
--AND source ='Cache'
AND Timestart>DATEADD(m,-1,GETDATE())
AND username NOT LIKE 'tor\07%'AND username NOT IN ('tor\011347','tor\011220') --Svetlana,Ruben
AND Source <>'Session'
GROUP BY ItemPath,CONVERT(DATE, TimeStart) 
HAVING COUNT(*)>1 ) t
ORDER BY itempath