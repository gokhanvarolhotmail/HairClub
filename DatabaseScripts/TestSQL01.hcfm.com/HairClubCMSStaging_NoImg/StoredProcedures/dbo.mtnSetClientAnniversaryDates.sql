/* CreateDate: 06/19/2017 06:51:00.123 , ModifyDate: 06/19/2017 06:51:00.123 */
GO
/*
==============================================================================
PROCEDURE:                  [mtnSetClientAnniversaryDates]

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Paul Madary

IMPLEMENTOR:                Paul Madary

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			07/13/2016

==============================================================================
DESCRIPTION:    Attempts to set datClient.AnniversaryDate if it hasn't already been set

==============================================================================
NOTES:
            * 06/14/2017 PRM - Created Stored Proc

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnSetClientAnniversaryDates]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnSetClientAnniversaryDates]
AS
BEGIN

UPDATE c1
SET AnniversaryDate = subAnnDate.AnniversaryServiceDate,
	LastUpdate = GETUTCDATE(),
	LastUpdateUser = 'Set Anniversary Date'
FROM datClient c1
	INNER JOIN (
	SELECT	c.ClientGUID, MIN(CAST(so.OrderDate AS DATE)) AS AnniversaryServiceDate
	FROM    datSalesOrderDetail sod WITH (NOLOCK)
			INNER JOIN datSalesOrder so WITH (NOLOCK) ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN cfgSalesCode sc WITH (NOLOCK) ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN datClientMembership cm WITH (NOLOCK) ON cm.ClientMembershipGUID = so.ClientMembershipGUID
			INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
			INNER JOIN lkpClientMembershipStatus cms ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN datClient c WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
	WHERE   c.AnniversaryDate IS NULL
			AND cms.ClientMembershipStatusDescription = 'Active'
			AND sc.SalesCodeDescriptionShort IN ('NB1A', 'EXTSVC', 'XTRNEWSRV', 'EXTSVCSOL', 'WEXTSVC')
			AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL', 'SHOWNOSALE', 'SNSSURGOFF')
			AND so.IsVoidedFlag = 0
	GROUP BY c.ClientGUID
	) subAnnDate ON c1.ClientGUID = subAnnDate.ClientGUID
END
GO
