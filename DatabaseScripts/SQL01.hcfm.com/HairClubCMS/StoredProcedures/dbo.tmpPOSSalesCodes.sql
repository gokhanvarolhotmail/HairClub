/* CreateDate: 11/05/2008 09:27:37.243 , ModifyDate: 02/27/2017 09:49:36.273 */
GO
/***********************************************************************

PROCEDURE:				tmpPOSSalesCodes

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns valid sales codes for the POS screen.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

tmpPOSSalesCodes '5D044E24-96C8-4C10-B097-51C16F6F05D4', 301

***********************************************************************/

CREATE PROCEDURE [dbo].[tmpPOSSalesCodes]
	@ClientMembershipGUID uniqueidentifier,
	@CenterID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT sc.*
    FROM cfgSalesCode sc
		INNER JOIN cfgSalesCodeCenter scc ON sc.SalesCodeID = scc.SalesCodeID
		LEFT JOIN cfgCenterTaxRate ctr1 ON scc.TaxRate1ID = ctr1.CenterTaxRateID
		LEFT JOIN cfgCenterTaxRate ctr2 ON scc.TaxRate2ID = ctr2.CenterTaxRateID
		INNER JOIN cfgSalesCodeMembership scm ON scc.SalesCodeCenterID = scm.SalesCodeCenterID
		INNER JOIN cfgMembership m ON scm.MembershipID = m.MembershipID
		INNER JOIN datClientMembership cm ON m.MembershipID = cm.MembershipID
	WHERE cm.ClientMembershipGUID = @ClientMembershipGUID
		AND scc.CenterID = @CenterID

END
GO
