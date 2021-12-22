/* CreateDate: 06/05/2015 10:53:44.440 , ModifyDate: 06/05/2015 10:53:44.440 */
GO
CREATE FUNCTION GetRestoreFileDIFF
(
	@FileNum int
)
RETURNS nvarchar(260)
AS
BEGIN

	DECLARE @backup_set_id_diff int;
	DECLARE @media_set_id_diff int;

	DECLARE @physical_device_name_diff_1 nvarchar(260);
	DECLARE @physical_device_name_diff_2 nvarchar(260);
	DECLARE @physical_device_name_diff_3 nvarchar(260);
	DECLARE @physical_device_name_diff_4 nvarchar(260);

	DECLARE @file_name_diff_1 nvarchar(260);
	DECLARE @file_name_diff_2 nvarchar(260);
	DECLARE @file_name_diff_3 nvarchar(260);
	DECLARE @file_name_diff_4 nvarchar(260);

	DECLARE @restore_file_diff_1 nvarchar(260);
	DECLARE @restore_file_diff_2 nvarchar(260);
	DECLARE @restore_file_diff_3 nvarchar(260);
	DECLARE @restore_file_diff_4 nvarchar(260);

	DECLARE @physical_device_name_prefix_diff nvarchar(260) = N'L:\SQLBackups\SQL01\HairClubCMS\DIFF\';
	DECLARE @restore_file_prefix_diff nvarchar(260) = N'\\sql01\SQLBackups\SQL01\HairClubCMS\DIFF\';

	-- Get backup_set_id and media_set_id for latest diff backup
	SELECT TOP 1 @backup_set_id_diff = [backup_set_id], @media_set_id_diff = [media_set_id] FROM [sql01].[msdb].[dbo].[backupset] WHERE [database_name] = 'HairClubCMS' AND [type] = 'I' ORDER BY backup_start_date DESC;

	-- Get physical device names for latest diff backup
	SELECT @physical_device_name_diff_1 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_diff AND family_sequence_number = 1;
	SELECT @physical_device_name_diff_2 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_diff AND family_sequence_number = 2;
	SELECT @physical_device_name_diff_3 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_diff AND family_sequence_number = 3;
	SELECT @physical_device_name_diff_4 = [physical_device_name] FROM [sql01].[msdb].[dbo].[backupmediafamily] WHERE media_set_id = @media_set_id_diff AND family_sequence_number = 4;

	-- Get file names for latest diff backup
	SELECT @file_name_diff_1 = RIGHT(@physical_device_name_diff_1, LEN(@physical_device_name_diff_1) - LEN(@physical_device_name_prefix_diff));
	SELECT @file_name_diff_2 = RIGHT(@physical_device_name_diff_2, LEN(@physical_device_name_diff_2) - LEN(@physical_device_name_prefix_diff));
	SELECT @file_name_diff_3 = RIGHT(@physical_device_name_diff_3, LEN(@physical_device_name_diff_3) - LEN(@physical_device_name_prefix_diff));
	SELECT @file_name_diff_4 = RIGHT(@physical_device_name_diff_4, LEN(@physical_device_name_diff_4) - LEN(@physical_device_name_prefix_diff));

	-- Get local file names for latest diff backup
	SELECT @restore_file_diff_1 = @restore_file_prefix_diff + @file_name_diff_1;
	SELECT @restore_file_diff_2 = @restore_file_prefix_diff + @file_name_diff_2;
	SELECT @restore_file_diff_3 = @restore_file_prefix_diff + @file_name_diff_3;
	SELECT @restore_file_diff_4 = @restore_file_prefix_diff + @file_name_diff_4;


	DECLARE @restore_file_diff nvarchar(260) = '';

	-- Return the result of the function
	IF @FileNum = 1
		SET @restore_file_diff = @restore_file_diff_1
	ELSE IF @FileNum = 2
		SET @restore_file_diff = @restore_file_diff_2
	ELSE IF @FileNum = 3
		SET @restore_file_diff= @restore_file_diff_3
	ELSE IF @FileNum = 4
		SET @restore_file_diff = @restore_file_diff_4;

	RETURN @restore_file_diff;

END
GO
