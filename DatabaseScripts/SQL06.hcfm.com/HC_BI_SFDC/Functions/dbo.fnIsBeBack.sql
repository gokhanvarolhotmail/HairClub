/* CreateDate: 09/29/2020 17:09:23.960 , ModifyDate: 09/29/2020 17:09:23.960 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fnIsBeBack (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50), @SourceCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN	(CASE WHEN @ActionCode IN ( 'Be Back' )
					AND @ResultCode NOT IN ( 'No Show' )
					AND @SourceCode NOT IN ( 'CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF'
										, 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
										) THEN 1
				ELSE 0
			END
		)
END
GO
