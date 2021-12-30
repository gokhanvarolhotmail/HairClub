/* CreateDate: 05/03/2010 12:26:22.790 , ModifyDate: 05/03/2010 12:26:22.790 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsNoSale]
		(
			@result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsNoSale] Identifies if result code is NOT a sale
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
	CASE WHEN @result_code IN ('SHOWNOSALE')	THEN 1
		 ELSE 0
	END
)
END
GO
