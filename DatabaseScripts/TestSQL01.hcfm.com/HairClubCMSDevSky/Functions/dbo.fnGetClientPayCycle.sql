/* CreateDate: 05/14/2014 09:39:06.530 , ModifyDate: 05/14/2014 10:36:28.227 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
