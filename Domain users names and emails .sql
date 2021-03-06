﻿/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [UserName]
,QC.WorkEmail
,Name
      ,[Path]
      ,[RoleName]
      ,[Type]
      ,[Description]
  FROM [ReportingDW].[dbo].[_ReportPermissionsSSRS] S  
	LEFT JOIN   [ReportingDW].[client].[QuestradeCatalog] QC
		ON S.UserName = QC.Login

    UPDATE  [ReportingDW].[dbo].[_ReportPermissionsSSRS]
	SET Username = REPLACE(Username,'tor\','')

SELECT C.Name 
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

DROP TABLE #ad
SELECT cn, sAMAccountName AS login, title, physicalDeliveryOfficeName, mail, telephoneNumber, mobile
			
			INTO #AD
			
			
			FROM OPENQUERY (
						ADSI,  
						'SELECT cn, sAMAccountName, title, physicalDeliveryOfficeName, mail, telephoneNumber, mobile
						FROM  ''LDAP://AQ1VPMTDC001.TOR.QUEST.COM/OU=Users,OU=Workstations,OU=Questrade - 5650 Yonge - Site 01,DC=TOR,DC=QUEST,DC=COM'' 
					') AS ADSI
			--WHERE cn IS NOT NULL
		
			
			union
			SELECT cn, sAMAccountName, title, physicalDeliveryOfficeName, mail, telephoneNumber, mobile
			FROM OPENQUERY (
						ADSI,  
						'SELECT cn, sAMAccountName, title, physicalDeliveryOfficeName, mail, telephoneNumber, mobile
						FROM  ''LDAP://. . . ./OU=Users,OU=Workstations,OU=Questrade - Armenia - Site 07,DC=TOR,DC=QUEST,DC=COM'' 
					') AS ADSI
			WHERE cn IS NOT NULL
		
			ORDER BY CN

SELECT * FROM #ad
  SELECT DISTINCT username
   FROM [dbo].[_ReportPermissionsSSRS] R LEFT	JOIN #AD L ON R.UserName  = L.Login
  WHERE L.Login IS NULL AND username LIKE '[0-9]%'
  ORDER BY username
