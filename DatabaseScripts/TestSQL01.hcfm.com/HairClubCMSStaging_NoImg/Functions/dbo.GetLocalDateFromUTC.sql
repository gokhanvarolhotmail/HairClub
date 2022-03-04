/* CreateDate: 03/02/2022 15:45:34.877 , ModifyDate: 03/02/2022 15:45:34.877 */
GO
CREATE FUNCTION [dbo].[GetLocalDateFromUTC]( @Input DATETIME )
RETURNS TABLE
AS
RETURN
SELECT CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, @Input), DATENAME(TZOFFSET, SYSDATETIMEOFFSET()))) AS [OutVal] ;
GO
