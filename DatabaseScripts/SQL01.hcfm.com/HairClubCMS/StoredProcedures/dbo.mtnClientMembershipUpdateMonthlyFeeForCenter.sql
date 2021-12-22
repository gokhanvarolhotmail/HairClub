/***********************************************************************

PROCEDURE:				mtnClientMembershipUpdateMonthlyFeeForCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 5/14/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnClientMembershipUpdateMonthlyFeeForCenter 201

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnClientMembershipUpdateMonthlyFeeForCenter]
	@CenterID int
AS
BEGIN
	SET NOCOUNT ON


	Update datClientMembership
		SET MonthlyFee = eft.amount
		,LastUpdate = GETUTCDATE()
		,lastUpdateUser = convert(nvarchar,'sa')
	FROM datClientMembership cm
			INNER JOIN dbo.datClient c ON cm.ClientGUID = c.ClientGUID
			INNER JOIN dbo.datClientEFT cEFT ON cEFT.ClientGUID = c.ClientGUID
			INNER JOIN [HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT eft on c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
			INNER JOIN [HCSQL2\SQL2005].INFOSTORE.dbo.Clients hcc on hcc.Center = c.CenterId
				AND hcc.Member1_ID = cm.Member1_ID_Temp
				AND hcc.Client_no = c.ClientNumber_Temp
	WHERE c.CenterID = @CenterID
END
