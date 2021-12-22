/***********************************************************************
PROCEDURE: 	[spApp_TokenTrigger]
DESTINATION SERVER:	   SQL01
DESTINATION DATABASE: HairClubCMS
RELATED APPLICATION:  NA
AUTHOR: HD
IMPLEMENTOR: HD
DATE IMPLEMENTED: 5/15/12
LAST REVISION DATE:
--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:
exec [spApp_TokenTrigger] 232
***********************************************************************/
create PROCEDURE [dbo].[spApp_TokenTrigger] (@CenterID INT) AS
BEGIN
	DECLARE @TOKJobName VARCHAR(200)
	DECLARE @SQL NVARCHAR(MAX)

	SELECT @TOKJobName = N'D_' + CASE [TimeZone]
			WHEN 0 THEN '2100'
			WHEN 1 THEN '2100'
			WHEN -1 THEN '2200'
			WHEN -2 THEN '2300'
			WHEN -3 THEN '2300'
		END  + '_TOK_IMP_' + CONVERT(VARCHAR, @CenterID) + '_' + [Center]
	FROM [HCSQL2\SQL2005].HCFMDirectory.dbo.tblcenter WHERE center_num = @CenterID

	--IF NOT EXISTS(SELECT job_id FROM msdb.dbo.sysjobs WHERE name = @TOKJobName )
	--BEGIN
	--	PRINT 'EXEC [spApp_CreateTokenImportJob]'  + CAST(@CenterID AS VARCHAR)
	--	EXEC [spApp_CreateTokenImportJob] @CenterID
	--END

	SET @SQL = N'EXEC msdb.dbo.SP_Start_job ''' + @TOKJobName + ''''

	PRINT @SQL
	EXEC dbo.sp_executesql @SQL
END
