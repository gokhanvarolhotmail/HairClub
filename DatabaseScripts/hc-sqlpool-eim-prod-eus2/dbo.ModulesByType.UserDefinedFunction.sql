/****** Object:  UserDefinedFunction [dbo].[ModulesByType]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ModulesByType] (@objectType [CHAR](2) = '%%') RETURNS TABLE
AS
RETURN (
	SELECT 
		sm.object_id AS 'Object Id',
		o.create_date AS 'Date Created',
		OBJECT_NAME(sm.object_id) AS 'Name',
		o.type AS 'Type',
		o.type_desc AS 'Type Description', 
		sm.definition AS 'Module Description'
	FROM sys.sql_modules AS sm  
	JOIN sys.objects AS o ON sm.object_id = o.object_id
	WHERE o.type like '%' + @objectType + '%'
)
GO
