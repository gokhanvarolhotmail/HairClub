/* CreateDate: 05/14/2012 17:41:00.253 , ModifyDate: 02/27/2017 09:49:18.083 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnClientMembershipUpdateMonthlyFee

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 2/1/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnClientMembershipUpdateMonthlyFee

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnClientMembershipUpdateMonthlyFee]
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
END
GO
