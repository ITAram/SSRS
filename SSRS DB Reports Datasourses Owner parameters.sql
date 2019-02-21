--GET list of Reports available in Reportserver Database

Select Name,Path,CreationDate,ModifiedDate from Catalog


--GET all available Datasource information in Report server database

Select distinct Name from DataSource Where Name is NOT NULL


--GET Datasource Information of specific report

Declare @Namespace NVARCHAR(500)
Declare @SQL   VARCHAR(max)
Declare  @ReportName NVARCHAR(850)
SET @ReportName='ClientOversight_AssetLevel(AMGMT-2)'

SELECT @Namespace= SUBSTRING(
				   x.CatContent  
				  ,x.CIndex
				  ,CHARINDEX('"',x.CatContent,x.CIndex+7) - x.CIndex
				)
	  FROM
     (
		 SELECT CatContent = CONVERT(NVARCHAR(MAX),CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)))
				,CIndex    = CHARINDEX('xmlns="',CONVERT(NVARCHAR(MAX),CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content))))
		   FROM Reportserver.dbo.Catalog C
		  WHERE C.Content is not null
			AND C.Type  = 2
	 ) X

SELECT @Namespace = REPLACE(@Namespace,'xmlns="','') + ''
SELECT @SQL = 'WITH XMLNAMESPACES ( DEFAULT ''' + @Namespace +''', ''http://schemas.microsoft.com/SQLServer/reporting/reportdesigner'' AS rd )
				SELECT  ReportName		 = name
					   ,DataSourceName	 = x.value(''(@Name)[1]'', ''VARCHAR(250)'') 
					   ,DataProvider	 = x.value(''(ConnectionProperties/DataProvider)[1]'',''VARCHAR(250)'')
					   ,ConnectionString = x.value(''(ConnectionProperties/ConnectString)[1]'',''VARCHAR(250)'')
				  FROM (  SELECT top 1 C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
						   FROM  ReportServer.dbo.Catalog C
						  WHERE  C.Content is not null
							AND  C.Type  = 2
							AND  C.Name  = ''' + @ReportName + '''
				  ) a
				  CROSS APPLY reportXML.nodes(''/Report/DataSources/DataSource'') r ( x )
				ORDER BY name ;'

EXEC(@SQL)


--Show owner details of specific report

Select C.Name,C.Path,U.UserName,C.CreationDate,C.ModifiedDate from Catalog C
INNER Join Users U ON C.CreatedByID=U.UserID
Where C.Name ='ClientOversight_AssetLevel(AMGMT-2)'



--Search in report server database for specific object

With Reports
AS
(
Select Name as ReportName,CONVERT(Varchar(Max),CONVERT(VARBINARY(MAX),Content)) AS ReportContent from  
Catalog Where Name is NOT NULL
)
Select ReportName,ReportContent from Reports Where ReportContent like '%lending%'

--Get Available Parameter with details in specific Report
SELECT Name as ReportName
		,ParameterName = Paravalue.value('Name[1]', 'VARCHAR(250)') 
	   ,ParameterType = Paravalue.value('Type[1]', 'VARCHAR(250)') 
	   ,ISNullable = Paravalue.value('Nullable[1]', 'VARCHAR(250)') 
	   ,ISAllowBlank = Paravalue.value('AllowBlank[1]', 'VARCHAR(250)') 
	   ,ISMultiValue = Paravalue.value('MultiValue[1]', 'VARCHAR(250)') 
	   ,ISUsedInQuery = Paravalue.value('UsedInQuery[1]', 'VARCHAR(250)') 
	   ,ParameterPrompt = Paravalue.value('Prompt[1]', 'VARCHAR(250)') 
	   ,DynamicPrompt = Paravalue.value('DynamicPrompt[1]', 'VARCHAR(250)') 
	   ,PromptUser = Paravalue.value('PromptUser[1]', 'VARCHAR(250)') 
	   ,State = Paravalue.value('State[1]', 'VARCHAR(250)') 
 FROM (  
		 SELECT top 1 C.Name,CONVERT(XML,C.Parameter) AS ParameterXML
		   FROM  ReportServer.dbo.Catalog C
		  WHERE  C.Content is not null
		AND  C.Type  = 2
		AND  C.Name  =  'Executive Summary(FIN-54)'
	  ) a
CROSS APPLY ParameterXML.nodes('//Parameters/Parameter') p ( Paravalue )

--Show owner details of specific report

Select C.Name,C.Path,U.UserName,C.CreationDate,C.ModifiedDate from Catalog C
INNER Join Users U ON C.CreatedByID=U.UserID
Where C.Name ='Executive Summary(FIN-54)'