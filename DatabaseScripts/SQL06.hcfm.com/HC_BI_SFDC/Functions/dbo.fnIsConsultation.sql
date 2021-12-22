CREATE FUNCTION fnIsConsultation (@ActionCode NVARCHAR(50),	@ResultCode NVARCHAR(50), @SourceCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN	(CASE WHEN @ActionCode NOT IN ( 'Be Back' )
					AND @ResultCode IN ( 'Show No Sale', 'Show Sale' )
					AND @SourceCode NOT IN ( 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSNCREF'
										, '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF'
										, 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
										) THEN 1
				ELSE 0
			END
		)
END
