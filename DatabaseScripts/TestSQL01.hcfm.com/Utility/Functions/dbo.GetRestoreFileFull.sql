/* CreateDate: 06/05/2015 10:32:26.927 , ModifyDate: 10/19/2018 22:31:47.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetRestoreFileFull]
(
	@FileNum int
)
RETURNS nvarchar(260)
AS
BEGIN

	DECLARE @backup_set_id_full int;
	DECLARE @media_set_id_full int;

	DECLARE @physical_device_name_full_1 nvarchar(260);
	DECLARE @physical_device_name_full_2 nvarchar(260);
	DECLARE @physical_device_name_full_3 nvarchar(260);
	DECLARE @physical_device_name_full_4 nvarchar(260);

	DECLARE @file_name_full_1 nvarchar(260);
	DECLARE @file_name_full_2 nvarchar(260);
	DECLARE @file_name_full_3 nvarchar(260);
	DECLARE @file_name_full_4 nvarchar(260);

	DECLARE @restore_file_full_1 nvarchar(260);
	DECLARE @restore_file_full_2 nvarchar(260);
	DECLARE @restore_file_full_3 nvarchar(260);
	DECLARE @restore_file_full_4 nvarchar(260);

	DECLARE @physical_device_name_prefix_full nvarchar(260) = N'L:\MSSQL\Backups\HCSQL01$HCSQL01AG\HairClubCMS\FULL\';
	DECLARE @restore_file_prefix_full nvarchar(260) = N'\\HCSQL011\HairClubCMS\FULL\';

	-- Get backup_set_id and media_set_id for latest full backup
	SELECT TOP 1 @backup_set_id_full = [backup_set_id], @media_set_id_full = [media_set_id] FROM [sql01].[msdb].[dbo].[backupset] WHERE [database_name] = 'HairClubCMS' AND [type] = 'D' ORDER BY backup_start_date DESC;

	-- Get physical device names for latest full backup
	SELECT @physical_device_name_full_1 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_full AND family_sequence_number = 1;
	SELECT @physical_device_name_full_2 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_full AND family_sequence_number = 2;
	SELECT @physical_device_name_full_3 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_full AND family_sequence_number = 3;
	SELECT @physical_device_name_full_4 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_full AND family_sequence_number = 4;

	-- Get file names for latest full backup
	SELECT @file_name_full_1 = RIGHT(@physical_device_name_full_1, LEN(@physical_device_name_full_1) - LEN(@physical_device_name_prefix_full));
	SELECT @file_name_full_2 = RIGHT(@physical_device_name_full_2, LEN(@physical_device_name_full_2) - LEN(@physical_device_name_prefix_full));
	SELECT @file_name_full_3 = RIGHT(@physical_device_name_full_3, LEN(@physical_device_name_full_3) - LEN(@physical_device_name_prefix_full));
	SELECT @file_name_full_4 = RIGHT(@physical_device_name_full_4, LEN(@physical_device_name_full_4) - LEN(@physical_device_name_prefix_full));

	-- Get local file names for latest full backup
	SELECT @restore_file_full_1 = @restore_file_prefix_full + @file_name_full_1;
	SELECT @restore_file_full_2 = @restore_file_prefix_full + @file_name_full_2;
	SELECT @restore_file_full_3 = @restore_file_prefix_full + @file_name_full_3;
	SELECT @restore_file_full_4 = @restore_file_prefix_full + @file_name_full_4;

	DECLARE @restore_file_full nvarchar(260) = '';

	-- Return the result of the function
	IF @FileNum = 1
		SET @restore_file_full = @restore_file_full_1
	ELSE IF @FileNum = 2
		SET @restore_file_full = @restore_file_full_2
	ELSE IF @FileNum = 3
		SET @restore_file_full = @restore_file_full_3
	ELSE IF @FileNum = 4
		SET @restore_file_full = @restore_file_full_4;

	RETURN @restore_file_full;

END
GO
