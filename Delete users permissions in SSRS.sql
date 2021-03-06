﻿SELECT C.Name 
      ,U.UserName 
      ,R.RoleName 
      ,R.Description 
      ,U.AuthType 
  FROM Reportserver.dbo.Users U 
  JOIN Reportserver.dbo.PolicyUserRole PUR 
    ON U.UserID = PUR.UserID 
  JOIN Reportserver.dbo.Policies P 
    ON P.PolicyID = PUR.PolicyID 
  JOIN Reportserver.dbo.Roles R 
    ON R.RoleID = PUR.RoleID 
  JOIN Reportserver.dbo.Catalog c 
    ON C.PolicyID = P.PolicyID 
 --WHERE c.Name = @ReportName 
ORDER BY U.UserName 

DROP TABLE #Temptable

CREATE TABLE #temptable (  [username] varchar(255) COLLATE Latin1_General_CI_AS_KS_WS )
INSERT INTO #temptable
VALUES
( '011015' ), 
( '011054' )

SELECT  [SecDataID]
      ,[PolicyID]
      ,[AuthType]
      ,[XmlDescription]
      ,[NtSecDescPrimary]
      ,[NtSecDescSecondary]
  FROM [ReportServer].[dbo].[SecData] s JOIN #temptable t
   ON XmlDescription LIKE '%'+t.username+'%'
   
DELETE  A
FROM dbo.PolicyUserRole A
  
    join dbo.Users C on A.UserID = C.UserID
   
JOIN #Temptable t ON C.UserName like '%'+t.Username


 GO 
--SELECT * FROM dbo.Catalog Ct join dbo.Users C on ct.CreatedByID = C.UserID
UPDATE ct 
SET ct.CreatedByID ='41861074-4BC3-4F47-8559-9738F4708E0E'
FROM dbo.Catalog Ct join dbo.Users C on ct.CreatedByID = C.UserID
JOIN #Temptable t ON REPLACE(C.UserName, 'TOR\','') = t.Username
go

UPDATE ct 
SET ct.CreatedbyId ='41861074-4BC3-4F47-8559-9738F4708E0E'
FROM dbo.Schedule Ct join dbo.Users C on ct.CreatedbyId = C.UserID
JOIN #Temptable t ON REPLACE(C.UserName, 'TOR\','') = t.Username

GO

UPDATE ct 
SET ct.CreatedById ='41861074-4BC3-4F47-8559-9738F4708E0E'
FROM dbo.Schedule Ct join dbo.Users C on ct.CreatedById = C.UserID
JOIN #Temptable t ON REPLACE(C.UserName, 'TOR\','') = t.Username

go
DELETE U FROM  dbo.Users U
JOIN #Temptable t ON REPLACE(U.UserName, 'TOR\','') = t.Username

GO

DECLARE @username1 varchar (100)
Declare @username2 varchar (100)
Declare @username3 varchar (100)
DECLARE db_cursor CURSOR FOR  SELECT username FROM #temptable


OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @username1   
WHILE @@FETCH_STATUS = 0   

BEGIN
	Set @username2 = 'TOR\'+@username1
	Set @username3 = 'tor\'+@username1
	DROP TABLE #Temp


	SELECT CAST(xmldescription AS xml) AS xmldescription , secdataid
	INTO #Temp
	FROM secdata

	UPDATE #temp 
	SET xmldescription.modify('delete /Policies/Policy[GroupUserName =sql:variable("@username1")]')


	UPDATE #temp 
	SET xmldescription.modify('delete /Policies/Policy[GroupUserName =sql:variable("@username2")]')


	UPDATE #temp 
	SET xmldescription.modify('delete /Policies/Policy[GroupUserName =sql:variable("@username3")]')

	UPDATE t
	SET xmldescription = tmp.xmldescription
	FROM secdata t
	INNER JOIN (SELECT CAST(xmldescription AS nvarchar(max)) AS xmldescription , secdataid
	FROM #Temp) tmp
	ON tmp.secdataid = t.secdataid

	--SELECT xmldescription, secdataid	FROM secdata

	DROP TABLE #Temp
	FETCH NEXT FROM db_cursor INTO @username1  
END


DROP TABLE #temptable
