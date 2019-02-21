 DECLARE @ReportName NVARCHAR(850) ='Sales Summary Report(MGMT-14)'
 DECLARE @ShowExecutionLog bit = 0 
 
Declare @Namespace NVARCHAR(500) 
Declare @SQL   VARCHAR(max) 
 
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

SELECT @SQL = 'WITH XMLNAMESPACES ( DEFAULT ''' + @Namespace + ''', ''http://schemas.microsoft.com/SQLServer/reporting/reportdesigner'' AS rd ) 
SELECT  ReportName        = name 
       ,DataSetName        = x.value(''(@Name)[1]'', ''VARCHAR(250)'')  
       ,DataSourceName    = x.value(''(Query/DataSourceName)[1]'',''VARCHAR(250)'') 
       ,CommandText        = x.value(''(Query/CommandText)[1]'',''VARCHAR(250)'') 
       ,Fields            = df.value(''(@Name)[1]'',''VARCHAR(250)'') 
       ,DataField        = df.value(''(DataField)[1]'',''VARCHAR(250)'') 
       ,DataType        = df.value(''(rd:TypeName)[1]'',''VARCHAR(250)'') 
  FROM (  SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML 
           FROM  ReportServer.dbo.Catalog C 
          WHERE  C.Content is not null 
            AND  C.Type = 2 
            --AND  C.Name = ''' + @ReportName + ''' 
       ) a 
  CROSS APPLY reportXML.nodes(''/Report/DataSets/DataSet'') r ( x ) 
  CROSS APPLY x.nodes(''Fields/Field'') f(df)  
ORDER BY name ' 
EXEC(@SQL) 