/* CreateDate: 05/03/2010 12:26:22.823 , ModifyDate: 05/03/2010 12:26:22.823 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsSale]
		(
			@result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsSale] Identifies if result code is a sale
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS bit AS
BEGIN
RETURN(
	CASE WHEN @result_code IN ('SHOWSALE')	THEN 1
		 ELSE 0
	END
)
END
GO
