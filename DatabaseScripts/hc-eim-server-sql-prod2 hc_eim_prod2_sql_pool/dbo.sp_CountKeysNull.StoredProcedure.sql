/****** Object:  StoredProcedure [dbo].[sp_CountKeysNull]    Script Date: 3/15/2022 2:11:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_CountKeysNull] @Schema [VARCHAR](100) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL	NVARCHAR(MAX)
    PRINT( 'SELECT	  ''SELECT ''''''	+ C.TABLE_NAME +	'''''' AS TABLE_NAME, '''''' + C.COLUMN_NAME +'''''' AS COLUMN_NAME, '' + C.COLUMN_NAME + '', COUNT(*) AS TOTAL_NULL''
							+ '' FROM ''		+ C.TABLE_SCHEMA +	''.'' + C.TABLE_NAME +
							+ '' WHERE ''		+ C.COLUMN_NAME +	'' IS NULL''
							+ '' GROUP BY ''	+ C.COLUMN_NAME
							+ '' HAVING COUNT(*) >=1; ''
							FROM INFORMATION_SCHEMA.TABLES T
							INNER JOIN INFORMATION_SCHEMA.COLUMNS C
								 ON T.TABLE_NAME = C.TABLE_NAME
							WHERE UPPER(C.COLUMN_NAME) LIKE ''%KEY''; ');

END
GO
