/* CreateDate: 03/11/2013 23:45:40.717 , ModifyDate: 12/19/2013 07:35:30.130 */
GO
/***********************************************************************
		PROCEDURE: 				[fn_GetClientAccumLastUsedDate]
		DESTINATION SERVER:		SQL01
		DESTINATION DATABASE:	HairClubCMS
		AUTHOR:					Michael Maass
		DATE IMPLEMENTED:		2013-01-11
		--------------------------------------------------------------------------------------------------------
		NOTES: Finds the MAX last used date for the accumulator.  The INNER SELECT may be used for testing.
		AccumulatorID	Description
		13				Hair System
		16				Services
		36				Solutions
		37				Product Kits

		12/3/2013	RHut	Changed to pull for all ClientMembershipGUID's
		--------------------------------------------------------------------------------------------------------
		Sample Execution:
		SELECT dbo.[fn_GetClientAccumLastUsedDate] ('62FB90B1-2209-42A6-B60F-3E2663BA2AA7', 13)

		SELECT dbo.[fn_GetClientAccumLastUsedDate] ('62FB90B1-2209-42A6-B60F-3E2663BA2AA7', 16)

		SELECT dbo.[fn_GetClientAccumLastUsedDate] ('F01B4A81-AABB-483A-8209-821631C2DAF9', 37)

		SELECT dbo.[fn_GetClientAccumLastUsedDate] ('904D1667-2F11-4E93-A118-001300BB2634',16)
		***********************************************************************/
		CREATE FUNCTION [dbo].[fn_GetClientAccumLastUsedDate]
		(
			@ClientGUID CHAR(36)
			,	@AccumulatorID INT
		)
		RETURNS DATETIME
		AS
		BEGIN

			DECLARE @LastUsed DATETIME

			SELECT @LastUsed =
							(SELECT MAX(CMA.AccumDate)
							FROM datClientMembershipAccum CMA
							INNER JOIN dbo.cfgAccumulator A
								ON CMA.AccumulatorID = A.AccumulatorID
							WHERE ClientMembershipGUID IN (SELECT ClientMembershipGUID   --Find all ClientMembershipGUID's for this client
															FROM dbo.datClientMembership
															WHERE ClientGUID = @ClientGUID)
							AND CMA.AccumulatorID = @AccumulatorID
							)
			RETURN @LastUsed

		END
GO
