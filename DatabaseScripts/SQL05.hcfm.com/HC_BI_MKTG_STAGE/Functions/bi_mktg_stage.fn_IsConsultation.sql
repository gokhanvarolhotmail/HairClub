/* CreateDate: 05/03/2010 12:26:22.770 , ModifyDate: 12/18/2020 16:31:31.403 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsConsultation]
		(
			  @action_code as varchar(10)
			, @result_code varchar(10)
		)
-----------------------------------------------------------------------
-- [fn_IsConsultation] Identifies if action code is considered a Consultation
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--		    12/18/20  KMurdoch	   Removed exclusion of Bebacks from Consultations
-----------------------------------------------------------------------

RETURNS bit AS
BEGIN
RETURN(

		CASE WHEN [bi_mktg_stage].fn_IsShow(@result_code) = 1
                  --AND @action_code NOT IN ( 'BEBACK' ) --Removed to count BeBacks as Consultations
				  THEN 1
             ELSE 0
		END
)
END
GO
