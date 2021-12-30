/* CreateDate: 05/03/2010 12:08:53.327 , ModifyDate: 09/24/2014 11:41:44.733 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [bief_dds].[DDS_DimTimeOfDay_Populate]

AS
-------------------------------------------------------------------------
-- [DDS_DimTimeOfDay_Populate] is used to load the Time Of Day Dimension
-- in seconds
--
--
--   EXEC [bief_dds].[DDS_DimTimeOfDay_Populate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET IDENTITY_INSERT [bief_dds].DimTimeOfDay ON

	DELETE FROM [bief_dds].[DimTimeOfDay]

	INSERT INTO [bief_dds].[DimTimeOfDay] (TimeOfDayKey, Time, Time24, Hour, HourName, Minute, MinuteKey, MinuteName, Second, Hour24, AM)
	VALUES (-1, 'Unknown', 'Unknown', -1, 'Unknown', -1, -1, 'Unknown', -1, -1, 'NA')

	DECLARE @DimTimeKey int, @Date datetime, @AM char(2),
		@hour24 tinyint, @hour tinyint, @minute tinyint, @second int, @hourname varchar(10), @time varchar(12)
		, @minutename varchar(20)
	SET @DimTimeKey = -1


	WHILE @DimTimeKey < (60*60*24)
	BEGIN
		SET @DimTimeKey = @DimTimeKey + 1
		SET @Date = DATEADD(second,@DimTimeKey,convert(datetime, '1/1/2000'))
		SET @AM = right(convert(varchar,@Date,109),2)
		SET @hour24 = DATEPART(hour, @Date)
		SET @hour = case when @AM = 'PM' then @hour24 - 12 else @hour24 end
		SET @minute = DATEPART(minute, @Date)
		SET @second = DATEPART(second, @Date)
		SET @hourname = CASE WHEN @hour24 = 0 then '12 AM'
							WHEN @hour24 = 12 then '12 PM'
							ELSE right('0' + convert(varchar,@hour),2) + ' ' + @AM
							END
		SET @time = CASE WHEN @hour24 = 0 THEN
							'12:' + right('0' + convert(varchar,@minute),2)
							+ ':' + right('0' + convert(varchar,@second),2) + ' ' + @AM
						WHEN @hour24 = 12 THEN
							'12:' + right('0' + convert(varchar,@minute),2)
							+ ':' + right('0' + convert(varchar,@second),2) + ' ' + @AM
						ELSE
							right('0' + convert(varchar,@hour),2)
							+ ':' + right('0' + convert(varchar,@minute),2)
							+ ':' + right('0' + convert(varchar,@second),2) + ' ' + @AM
						END

		SET @minutename = CASE WHEN @hour24 = 0 THEN
							'12:' + right('0' + convert(varchar,@minute),2)+ ' ' + @AM
						WHEN @hour24 = 12 THEN
							'12:' + right('0' + convert(varchar,@minute),2)+ ' ' + @AM
						ELSE
							right('0' + convert(varchar,@hour),2)
							+ ':' + right('0' + convert(varchar,@minute),2)+ ' ' + @AM
						END

		INSERT INTO [bief_dds].[DimTimeOfDay](TimeOfDayKey,Time,Time24,Hour,HourName,Minute,MinuteKey,MinuteName,Second,Hour24,AM)
		SELECT	@DimTimeKey,
				Time = @time,
				Time24 = convert(varchar,@Date,108),
				@hour,
				HourName = @hourname,
				@minute,
				MinuteKey = (@hour24*60) + @minute,
				MinuteName = @minutename,
				@second, @hour24, @AM
	END

	SET IDENTITY_INSERT [bief_dds].[DimTimeOfDay] OFF

	-- Cleanup
	-- Reset SET NOCOUNT to OFF.
	SET NOCOUNT OFF

	-- Cleanup temp tables

	-- Return success
	RETURN 0

END
GO
