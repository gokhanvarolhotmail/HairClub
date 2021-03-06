/* CreateDate: 02/18/2013 06:45:39.343 , ModifyDate: 02/27/2017 09:49:20.863 */
GO
/***********************************************************************

PROCEDURE:				mtnGetSalesCodeImageByCenter	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/18/2012

LAST REVISION DATE:		4/18/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/16/2012	KMurdoch	Initial Creation
	4/17/2012	agile.wupchurch	Added SalesCodeID

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetSalesCodeImageByCenter '201'

	CenterID = Logged in Center

	Sales Code Types
	1 = Product
	2 = Service
	3 = ARPayment
	4 = Membership
	5 = Misc
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetSalesCodeImageByCenter] (
	@CenterID int

) AS
	BEGIN


	SET NOCOUNT ON

	SELECT
			sc.SalesCodeID as 'ID'
		,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		,	sc.SalesCodeDescription as 'SalesCodeDescription'
		,	sc.SalesCodeTypeID
		,	sct.SalesCodeTypeDescriptionShort
		,	sci.SalesCodeImage

	FROM cfgsalescodecenter scc

		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join lkpSalesCodeType sct
			on sc.SalesCodeTypeID = sct.SalesCodeTypeID
		left outer join lkpSalesCodeImage sci
			on sc.SalesCodeID = sci.salescodeid
	WHERE
		scc.CenterID = @CenterID
	order by sc.salescodetypeid,sc.SalesCodeDepartmentID,sc.SalesCodeDescription
END
GO
