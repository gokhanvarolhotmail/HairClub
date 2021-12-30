/* CreateDate: 05/14/2015 20:35:07.190 , ModifyDate: 05/14/2015 20:40:08.593 */
GO
-- =============================================
-- Author:		Edmund Poillion
-- Create date: 5/14/2015
-- Description:	This stored procedure generates a simple report of the backup events which occured yesterday for SQL01.HairClubCMS.
-- =============================================
CREATE PROCEDURE GenerateBackupReport
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TodaysDate date = CAST(GETDATE() AS date);
	DECLARE @QueryStartDate datetime = CAST(DATEADD(DAY, -1, @TodaysDate) AS datetime);
	DECLARE @QueryEndDate datetime = CAST(@TodaysDate AS datetime);

	DECLARE @Subject nvarchar(255) = 'Backup Report for SQL01.HairClubCMS for ' + CONVERT(VARCHAR(8), @QueryStartDate, 112);

	WITH
	BackupExecFullBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] = 'D'
			AND [name] = 'Backup Exec SQL Server Agent'
	),
	BackupExecLogBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] = 'L'
			AND [name] = 'Backup Exec SQL Server Agent'
	),
	BackupExecOtherBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] NOT IN ('D', 'L')
			AND [name] = 'Backup Exec SQL Server Agent'
	),
	OtherFullBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] = 'D'
			AND [name] <> 'Backup Exec SQL Server Agent'
	),
	OtherLogBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] = 'L'
			AND [name] <> 'Backup Exec SQL Server Agent'
	),
	OtherOtherBackupList AS
	(
		SELECT
			[server_name],
			[machine_name],
			[database_name],
			[name],
			[description],
			[user_name],
			[backup_start_date],
			[backup_finish_date],
			[type],
			[is_copy_only],
			[has_backup_checksums],
			CAST(([backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [backup_size (MB)],
			CAST(([compressed_backup_size] / (1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (MB)],
			CAST(([backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [backup_size (GB)],
			CAST(([compressed_backup_size] / (1024 * 1024 * 1024)) AS decimal(18,2)) AS [compressed_backup_size (GB)]
		FROM
			[msdb].[dbo].[backupset]
		WHERE
			1=1
			AND [backup_start_date] >= @QueryStartDate
			AND [backup_start_date] < @QueryEndDate
			AND [database_name] = 'HairClubCMS'
			AND [type] NOT IN ('D', 'L')
			AND [name] <> 'Backup Exec SQL Server Agent'
	)
	SELECT * FROM BackupExecFullBackupList UNION ALL
	SELECT * FROM BackupExecLogBackupList UNION ALL
	SELECT * FROM BackupExecOtherBackupList UNION ALL
	SELECT * FROM OtherFullBackupList UNION ALL
	SELECT * FROM OtherLogBackupList UNION ALL
	SELECT * FROM OtherOtherBackupList

END
GO
