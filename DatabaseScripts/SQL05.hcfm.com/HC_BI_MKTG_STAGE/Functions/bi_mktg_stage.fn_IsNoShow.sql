/* CreateDate: 05/03/2010 12:26:22.807 , ModifyDate: 05/03/2010 12:26:22.807 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsNoShow]
		(
			@result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsNoShow] Identifies if result code is considered a No Show
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
	CASE WHEN @result_code IN ('NOSHOW') THEN 1
		 ELSE 0
	END
)
END
GO
