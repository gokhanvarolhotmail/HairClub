/* CreateDate: 06/23/2014 15:01:41.207 , ModifyDate: 11/09/2016 12:04:25.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetSTDDateFromUTC]
(
	@dDate AS DATETIME
,	@CenterSSID AS INT
)
-----------------------------------------------------------------------
-- [fn_GetUTCDateTime] Takes in a date and a center and returns a
-- converted FROM UTC Date and Time
--
-- SELECT [dbo].[fn_GetSTDDateFromUTC]('2010-05-29 16:54:00', 210)
-----------------------------------------------------------------------
RETURNS DATETIME
AS
BEGIN
DECLARE @UTCDate DATETIME

SELECT  @UTCDate = dbo.GetLocalFromUTC (@dDate, z.UTCOffset, z.UsesDayLightSavingsFlag)
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimTimeZone z
            ON c.TimeZoneKey = z.TimeZoneKey
WHERE   c.CenterSSID = @CenterSSID

RETURN @UTCDate
END
GO
