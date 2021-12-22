/* CreateDate: 05/31/2011 10:32:04.950 , ModifyDate: 09/16/2019 09:33:49.877 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  FUNCTION [dbo].[DIVIDE] (@numerator numeric, @denominator numeric)
RETURNS float

AS

	BEGIN
		DECLARE @fProduct AS FLOAT

		IF  @denominator = 0
			SET @fProduct = 0
		ELSE
			SET @fProduct = (SUM(CONVERT(money, @numerator)) / SUM(CONVERT(money, @denominator)))

		RETURN @fProduct

	END
GO
