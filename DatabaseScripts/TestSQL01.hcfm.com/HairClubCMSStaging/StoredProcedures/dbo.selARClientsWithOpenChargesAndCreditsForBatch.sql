/* CreateDate: 03/14/2013 23:16:13.590 , ModifyDate: 03/14/2013 23:16:13.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selARClientsWithOpenChargesAndCreditsForBatch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		03/04/2013

LAST REVISION DATE: 	03/04/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns clients for the fee batch that have open credits and open charges that the credits can be
		applied to.  A client must have at least 1 open credit AND at least 1 open charge to qualify.

		03/04/2013 - MVT: Created Stored Proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[selARClientsWithOpenChargesAndCreditsForBatch] 'F2E511F6-9A77-4ACB-8558-A8B6594DC621', null

***********************************************************************/
CREATE PROCEDURE [dbo].[selARClientsWithOpenChargesAndCreditsForBatch]
	@CenterFeeBatchGuid as uniqueidentifier,
	@CenterDeclineBatchGuid as uniqueidentifier

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CenterFeeBatchGuid IS NOT NULL
	BEGIN

		SELECT distinct(arCredit.ClientGuid)
		FROM datAccountReceivable arCredit
			INNER JOIN lkpAccountReceivableType typeCredit ON arCredit.AccountReceivableTypeID = typeCredit.AccountReceivableTypeID
														AND typeCredit.IsCreditFlag = 1
			INNER JOIN datAccountReceivable arCharge ON arCredit.ClientGuid = arCharge.ClientGuid
			INNER JOIN lkpAccountReceivableType typeCharge ON typeCharge.AccountReceivableTypeID = arCharge.AccountReceivableTypeID
														AND typeCharge.IsCreditFlag = 0
		WHERE arCharge.CenterFeeBatchGuid = @CenterFeeBatchGuid
				AND arCharge.IsClosed = 0 AND arCredit.IsClosed = 0

	END
	ELSE
	BEGIN

		SELECT distinct(arCredit.ClientGuid)
		FROM datAccountReceivable arCredit
			INNER JOIN lkpAccountReceivableType typeCredit ON arCredit.AccountReceivableTypeID = typeCredit.AccountReceivableTypeID
														AND typeCredit.IsCreditFlag = 1
			INNER JOIN datAccountReceivable arCharge ON arCredit.ClientGuid = arCharge.ClientGuid
			INNER JOIN lkpAccountReceivableType typeCharge ON typeCharge.AccountReceivableTypeID = arCharge.AccountReceivableTypeID
														AND typeCharge.IsCreditFlag = 0
		WHERE arCredit.CenterDeclineBatchGuid = @CenterDeclineBatchGuid
				AND arCharge.IsClosed = 0 AND arCredit.IsClosed = 0

	END

END
GO
