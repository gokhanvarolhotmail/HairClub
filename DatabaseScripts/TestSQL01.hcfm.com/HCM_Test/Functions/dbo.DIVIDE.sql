/* CreateDate: 10/17/2007 08:55:07.277 , ModifyDate: 05/01/2010 14:48:09.133 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[DIVIDE]
    (
      @numerator numeric,
      @denominator numeric
    )
RETURNS float
AS

BEGIN
	DECLARE @ret float
     IF( @denominator = 0)
			SET @ret = 0
      ELSE
			SET @ret = SUM(CONVERT(smallmoney, @numerator)) / SUM(CONVERT(smallmoney, @denominator))

	RETURN (@ret)
END;
GO
