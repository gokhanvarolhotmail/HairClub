/* CreateDate: 10/03/2006 10:21:24.117 , ModifyDate: 10/03/2006 10:21:24.117 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.F_WeekCommence (@MidWeekDate DateTime)
RETURNS DateTime AS

BEGIN
DECLARE @WeekCommence DateTime
	SET @WeekCommence = DateAdd(d, -((@@DATEFIRST + DatePart(dw, @MidWeekDate) -2) % 7), @MidWeekDate)
	RETURN @WeekCommence
END
GO
