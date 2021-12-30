/* CreateDate: 05/03/2010 12:26:22.753 , ModifyDate: 02/18/2019 15:57:48.240 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsBeBack]
		(
			  @action_code as varchar(10)
			, @result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsBeBack] Identifies if action code is considered a BeBack
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--			02/18/19  KMurdoch	   Added NoShow Exclusion logic
-----------------------------------------------------------------------

RETURNS bit AS
BEGIN
RETURN(

		CASE WHEN [bi_mktg_stage].fn_IsShow(@result_code) = 1
                  AND @action_code IN ( 'BEBACK' )
				  AND @result_code NOT IN ( 'NOSHOW' ) THEN 1
             ELSE 0
		END
)
END
GO
