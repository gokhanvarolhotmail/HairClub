/* CreateDate: 05/03/2010 12:26:22.837 , ModifyDate: 05/03/2010 12:26:22.837 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsShow]
		(
			@result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsShow] Identifies if result code is considered a show
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
	CASE WHEN @result_code IN ('SHOWSALE','SHOWNOSALE') THEN 1
		 ELSE 0
	END
)
END
GO
