/* CreateDate: 05/03/2010 12:26:22.737 , ModifyDate: 08/10/2020 12:17:22.253 */
GO
CREATE FUNCTION [bi_mktg_stage].[fn_IsAppointment]
    (
      @action_code as varchar(10)
	, @result_code varchar(10)
   )
-----------------------------------------------------------------------
-- [fn_IsAppointment] Identifies if action code is an appointment
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author		Description
-- -------  --------  -----------  -------------------------------------
--  v1.0				RLifke      Initial Creation
--			11/13/2017	RHut		Added VOID to the statement ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' ))
--			08/10/2020  KMurdoch    Added ManCrd to exclusion list
-----------------------------------------------------------------------

RETURNS bit
AS
BEGIN
    RETURN (
		CASE WHEN @action_code IN ( 'APPOINT' , 'INHOUSE')
				AND (@result_code NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN','VOID','MANCRD' )
				OR  @result_code IS NULL
				OR  @result_code = '' ) THEN 1
             ELSE 0
             END
           )
   END
GO
