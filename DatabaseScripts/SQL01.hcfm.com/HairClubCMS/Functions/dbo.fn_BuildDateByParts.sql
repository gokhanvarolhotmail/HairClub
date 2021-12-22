--SELECT [dbo].[fn_BuildDateByParts] (5, 1, 2008)
CREATE FUNCTION [dbo].[fn_BuildDateByParts] (@DatePartMonth INT, @DatePartDay INT, @DatePartYear INT)
	RETURNS datetime
	AS
	BEGIN
	RETURN(
		CONVERT(DATETIME, CONVERT(VARCHAR(2), @DatePartMonth) + '/' + CONVERT(VARCHAR(2), @DatePartDay) + '/' + CONVERT(VARCHAR(4), @DatePartYear))
	)
	END
