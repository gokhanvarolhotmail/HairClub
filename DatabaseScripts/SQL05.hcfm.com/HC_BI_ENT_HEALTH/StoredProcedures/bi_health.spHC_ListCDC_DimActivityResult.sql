/* CreateDate: 05/03/2010 20:08:59.740 , ModifyDate: 05/06/2010 16:38:52.320 */
GO
CREATE PROCEDURE [bi_health].[spHC_ListCDC_DimActivityResult]
		  @TimeIncrement		int = 1
		, @TimeIncrementUnit	varchar(10) = 'DAY' -- day,hour,minute

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_NumCDC_DimActivityResult]
--
-- EXEC [bi_health].[spHC_ListCDC_DimActivityResult] 5, 'DAY'
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DECLARE	  @Start_Time			datetime = null
				, @End_Time				datetime = null
				, @row_filter_option	nvarchar(30) = N'all'
				, @CDCTableName			varchar(150) = N'dbo_cstd_contact_completion'	-- Name of CDC table
				, @From_LSN				binary(10)
				, @To_LSN				binary(10)

		SET @End_Time = GETDATE()

		-- Get last 5 minutes
		SET @Start_Time = DATEADD(minute, -5, @End_Time)
		IF (UPPER(@TimeIncrementUnit) = 'MINUTE')
			BEGIN
				SET @Start_Time = DATEADD(minute, (-1) * @TimeIncrement, @End_Time)
			END
		IF (UPPER(@TimeIncrementUnit) = 'HOUR')
			BEGIN
				SET @Start_Time = DATEADD(hour, (-1) * @TimeIncrement, @End_Time)
			END
		IF (UPPER(@TimeIncrementUnit) = 'DAY')
			BEGIN
				SET @Start_Time = DATEADD(day, (-1) * @TimeIncrement, @End_Time)
			END

		-- Get the beginning LSN in range
		BEGIN
			IF ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
			   ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
					SELECT @From_LSN = [HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
			ELSE
				SELECT @From_LSN = [HCM].[sys].[fn_cdc_increment_lsn]([HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
		END

		-- Get the ending LSN
		BEGIN
			IF [HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
				SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
			ELSE
				SELECT @To_LSN = [HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
		END

		-- Get the times
		SELECT @Start_Time = [HCM].[sys].[fn_cdc_map_lsn_to_time](@From_LSN)
		SELECT @End_Time = [HCM].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)


		SELECT @Start_Time AS ChangesFromTime
				, @End_Time AS ChangesToTime
				, [HCM].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS ChangeTime
				, CASE [__$operation]
						WHEN 1 THEN 'D'
						WHEN 2 THEN 'I'
						WHEN 3 THEN 'UO'
						WHEN 4 THEN 'UN'
						WHEN 5 THEN 'M'
						ELSE NULL
					END AS [CDC_Operation]
				, *
		FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_cstd_contact_completion](@From_LSN, @To_LSN, @row_filter_option) chg
		ORDER BY ChangeTime

END
GO
