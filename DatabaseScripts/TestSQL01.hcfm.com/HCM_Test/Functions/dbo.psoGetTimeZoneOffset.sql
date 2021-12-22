/* CreateDate: 01/03/2013 10:22:38.770 , ModifyDate: 01/03/2013 10:22:38.770 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoGetTimeZoneOffset
(
	@TimeZoneCode NCHAR(10)
)
RETURNS FLOAT
AS
BEGIN

	DECLARE @OffSet FLOAT

	SELECT TOP 1
	@OffSet = onca_time_zone.greenwich_offset
	FROM onca_time_zone
	WHERE onca_time_zone.time_zone_code =  @TimeZoneCode

	RETURN @OffSet

END
GO
