/* CreateDate: 04/18/2012 16:51:08.623 , ModifyDate: 04/18/2012 17:02:03.477 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select [dbo].[fxPercentToString] (.12)
CREATE FUNCTION [dbo].[fxNumberToPercentString] (
	@Number DECIMAL(25,4))
RETURNS varchar(120)
AS
BEGIN
	DECLARE @tmp VARCHAR(120)
	SET @tmp=CAST(CAST((CAST(@Number as decimal(25,4)) * 100) as decimal(9, 0)) as varchar)
	RETURN SUBSTRING(CONVERT(VARCHAR, CAST(@tmp AS MONEY), 1), 1, LEN(CONVERT(VARCHAR, CAST(@tmp AS MONEY), 1)) - 3) + '%'
END
GO
