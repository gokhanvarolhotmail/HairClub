/* CreateDate: 01/04/2013 13:09:01.090 , ModifyDate: 01/04/2013 13:13:56.167 */
GO
CREATE    FUNCTION [bi_health].[fnHC_FormatANumber] (@Int int)
-----------------------------------------------------------------------
-- [fnHC_ConvertAgentHistoryDateTimes]
--
--SELECT [bi_health].[fnHC_FormatANumber](83500)
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	           EKnapp       Initial Creation
-----------------------------------------------------------------------

RETURNS varchar(30)
BEGIN

		DECLARE	 @Ret				varchar(30),
			     @Wk                varchar(33)

		SET @Wk =  convert(varchar(33),Convert(money, @Int),1)
		SET @Ret =  LEFT(@Wk, Len(@Wk) - 3)

RETURN @Ret
END
GO
