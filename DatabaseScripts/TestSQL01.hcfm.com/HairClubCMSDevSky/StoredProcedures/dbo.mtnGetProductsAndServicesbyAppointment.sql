/* CreateDate: 02/18/2013 06:45:39.317 , ModifyDate: 02/27/2017 09:49:20.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnGetProductsAndServicesbyAppointment	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Zack Buckley

IMPLEMENTOR:			Zack Buckley

DATE IMPLEMENTED:		6/06/2012

LAST REVISION DATE:		6/06/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	6/06/2012	agile.zbuckley	Initial Creation


--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetProductsAndServicesbyAppointment '201','41CCABDC-69CF-4E53-90BF-B5AA0EC1822E'

	CenterID = Logged in Center
	AppointmentGUID = From datAppointment - AppointmentGUID
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetProductsAndServicesbyAppointment] (
	@CenterID int
,	@AppointmentGUID UniqueIdentifier
)
 AS
	BEGIN

	SET NOCOUNT ON

	DECLARE @ClientMembershipGUID UniqueIdentifier
	SET @ClientMembershipGUID = (SELECT ClientMembershipGuid from datAppointment where AppointmentGUID = @AppointmentGUID)

	SELECT
			sc.SalesCodeID as 'ID'
		,	sc.SalesCodeDepartmentID as 'DepartmentID'
		,	scd.SalesCodeDepartmentDescription as 'DepartmentDescription'
		,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		,	sc.SalesCodeDescription as 'SalesCodeDescription'
		,	ISNULL(ISNULL(cscm.Price, scc.PriceRetail), 0) as 'Price'
		,	ISNULL(cctr1.TaxRate,0) as 'TaxRate1'
		,	ISNULL(cctr2.TaxRate,0) as 'TaxRate2'
		,	sc.IsSalesCodeKitFlag as 'IsSalesCodeKitFlag'
		,   sct.SalesCodeTypeDescriptionShort
	FROM datClientMembership clm
		inner join cfgSalesCodeMembership cscm
			on clm.MembershipID = cscm.MembershipID
		inner join cfgsalescodecenter scc
			on cscm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join lkpSalesCodeType sct
			on sc.SalesCodeTypeID = sct.SalesCodeTypeID
		inner join lkpSalesCodeDepartment scd
			on sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
		left outer join cfgCenterTaxRate cctr1
			on ISNULL(cscm.TaxRate1ID, scc.TaxRate1ID) = cctr1.CenterTaxRateID
		left outer join cfgCenterTaxRate cctr2
			on ISNULL(cscm.TaxRate2ID, scc.TaxRate2ID) = cctr2.CenterTaxRateID
	WHERE
		scc.CenterID = @CenterID
		and clm.ClientMembershipGUID = @clientmembershipguid
		and sct.SalesCodeTypeDescriptionShort in ('Product', 'Service')
	order by scd.SalesCodeDepartmentSortOrder,sc.SalesCodeDescription
END
GO
