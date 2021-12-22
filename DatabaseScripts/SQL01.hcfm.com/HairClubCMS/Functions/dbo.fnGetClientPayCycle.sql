CREATE FUNCTION [dbo].[fnGetClientPayCycle]
(
	@ClientIdentifier INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @PayCycleCount INT
    DECLARE @PayCycle VARCHAR(MAX)


	SELECT  @PayCycleCount = COUNT(DISTINCT LFPC.FeePayCycleID)
	FROM    datClient DC
			INNER JOIN datClientEFT DCE
				ON DCE.ClientGUID = DC.ClientGUID
			INNER JOIN lkpFeePayCycle LFPC
				ON DCE.FeePayCycleID = LFPC.FeePayCycleID
	WHERE   DC.ClientIdentifier = @ClientIdentifier


	IF @PayCycleCount > 1
	   BEGIN
			 SELECT @PayCycle = COALESCE(@PayCycle + ', ', '') + LFPC.FeePayCycleDescription
			 FROM   datClient DC
					INNER JOIN datClientEFT DCE
						ON DCE.ClientGUID = DC.ClientGUID
					INNER JOIN lkpFeePayCycle LFPC
						ON DCE.FeePayCycleID = LFPC.FeePayCycleID
			 WHERE  DC.ClientIdentifier = @ClientIdentifier
	   END
	ELSE
	   BEGIN
			 SELECT	DISTINCT
					@PayCycle = COALESCE(@PayCycle + ', ', '') + LFPC.FeePayCycleDescription
			 FROM   datClient DC
					INNER JOIN datClientEFT DCE
						ON DCE.ClientGUID = DC.ClientGUID
					INNER JOIN lkpFeePayCycle LFPC
						ON DCE.FeePayCycleID = LFPC.FeePayCycleID
			 WHERE  DC.ClientIdentifier = @ClientIdentifier
	   END


    RETURN @PayCycle
END
