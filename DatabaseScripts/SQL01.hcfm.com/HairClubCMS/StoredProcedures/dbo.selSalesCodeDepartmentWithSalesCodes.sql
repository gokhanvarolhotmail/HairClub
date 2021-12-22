--Delete from [cfgMembershipAccum] Where CreateUser = 'TFS2908'
--DELETE FROM cfgCenterMembership where CreateUser = 'TFS2908'
--Delete from [cfgMembershipRule] Where CreateUser = 'TFS2908'
--DELETE FROM cfgSalesCodeMembership where CreateUser = 'TFS2908'
--DELETE FROM cfgSalesCodeCenter where CreateUser = 'TFS2908'
--GO

/***********************************************************************

PROCEDURE:				selSalesCodeDepartmentWithSalesCodes

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe

IMPLEMENTOR: 			Andrew Schwalbe

DATE IMPLEMENTED: 		03/06/2009

LAST REVISION DATE: 	03/21/2019

--------------------------------------------------------------------------------------------------------
NOTES: 	Return departments and their sales codes
				for the current center and client membership
				along with information needed to calculate the
				proper price and tax for the sales codes.

		03/06/2009 - AS: Created Stored Proc
		07/02/2009 - AS:  Modify to return only those with CanOrderFlag = True
		08/04/2009 - PRM: Allowed AR Refund to be returned for Inactive memberships
		05/08/2009 - PRM:   Added logic to show Cancel Fee Sales code even if a membership is Cancelled
                            Sharepoint Issue Tracker #168:  Need to allow product purchases for Inactive clients.
						    * Added LEFT Join to sales code type then modified the where statment on the client membership
						      IsActiveFlag to be IsActive = 1 OR the sales code type = 'Product'
		06/21/2010 - PRM: Reusing proc and removing cancellation fee logic as was completed in application
		10/11/2012 - JGE: Removed Active membership limitation.
		11/17/2012 - JGE: Added SalesCodeTypeDescriptionShort to select
		12/10/2012 - JGE: Added IsQuantityAdjustableFlag to select
		12/12/2012 - JGE: Add logic to exclude NB1 salesCode if initial hair application has occured.
		03/24/2013 - JGE: Add new columns: BrandID, Product, Desciption, BrandDescription
		04/30/2014 - MLM: Added new Column: IsQuantityRequired
		08/26/2014 - SAL: Added filter for sales code being active in a center and for the membership in a center.
							scc.IsActiveFlag = 1 (cfgSalesCodeCenter) and scm.IsActiveFlag = 1 (cfgSalesCodeMembership) to where clause
		04/26/2016 - SAL: Added scc.AgreementID to select
		12/01/2016 - MVT: Excluded External Sales Codes
		07/18/2017 - SAL: Added scc.IsActiveFlag and scm.IsActiveFlag to select (TFS #9289)
		03/19/2018 - SAL: Removed "AND IsExternal = 0" from WHERE in final SELECT statement (TFS #10365)
		09/01/2017 - MVT: Added sc.IsSerialized and sc.SerialNumberRegEx to be returned in Select (TFS #9522)
		10/25/2018 - MVT: Added a check to exclude Sales Codes that have IsManagedByClientOnly set to True (TFS #11473)
		03/21/2019 - JLM: Add sc.IsBosleySalesCode to select (TFS #12048)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selSalesCodeDepartmentWithSalesCodes 240, 'EF8DE079-C2D5-4FBB-9FCD-8C12613E687C'

***********************************************************************/
CREATE PROCEDURE [dbo].[selSalesCodeDepartmentWithSalesCodes]
	@currentCenter as int,
	@clientMembershipGuid as uniqueidentifier
AS
BEGIN

	DECLARE @NB1ApplicationOccured bit
	SET @NB1ApplicationOccured = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check for initial application of hair system.
	IF EXISTS (Select *
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod ON so.salesorderguid = sod.salesorderguid
	WHERE so.clientmembershipguid = @clientMembershipGuid and so.IsVoidedFlag = 0 and so.isclosedFlag = 1 and sod.salescodeid = 648 )
	SET @NB1ApplicationOccured = 1

	SELECT scd.SalesCodeDepartmentID, scd.SalesCodeDepartmentSortOrder, scd.SalesCodeDepartmentDescription, scd.SalesCodeDepartmentDescriptionShort,
	       sc.IsDiscountableFlag, sc.IsPriceAdjustableFlag, sc.IsQuantityAdjustableFlag, sc.IsRefundableFlag, sc.PriceDefault,
				sc.SalesCodeDepartmentID as 'SalesCodeDepartmentID_SC', sc.SalesCodeDescription,
				sc.SalesCodeDescriptionShort, sc.SalesCodeID, sc.SalesCodeSortOrder, sc.SalesCodeTypeID,
				sc.BrandId, sc.Product, sc.Size, sc.IsQuantityRequired, sc.IsSerialized, sc.SerialNumberRegEx,
				lb.BrandDescription,
				sct.SalesCodeTypeDescriptionShort, scc.CenterID, scc.PriceRetail, scc.SalesCodeCenterID,
				scc.SalesCodeID as 'SalesCodeID_SCC', scc.TaxRate1ID, scc.TaxRate2ID, scc.AgreementID, scc.IsActiveFlag as 'IsActive_SCC',
		   scm.MembershipID, scm.Price, scm.SalesCodeCenterID AS 'SalesCodeCenterID_SCM',
				scm.SalesCodeMembershipID, scm.TaxRate1ID as 'TaxRate1_SCM', scm.TaxRate2ID as 'TaxRate2_SCM', scm.IsActiveFlag as 'IsActive_SCM',
		   cm.CenterID AS 'CenterID_CM', cm.ClientGUID, cm.ClientMembershipGUID, cm.ClientMembershipStatusID,
				cm.ContractPaidAmount, cm.ContractPrice, cm.MembershipID AS 'MembershipID_CM', cm.MonthlyFee,
		   ctrc1.CenterID As 'CenterID_CTaxRate1_SCC', ctrc1.CenterTaxRateID AS 'CenterTaxRateID_CTaxRate1_SCC',
				ctrc1.TaxRate AS 'TaxRate_CTaxRate1_SCC', ctrc1.TaxTypeID AS 'TaxTypeID_CTaxRate1_SCC',
		   ctrc2.CenterID As 'CenterID_CTaxRate2_SCC', ctrc2.CenterTaxRateID AS 'CenterTaxRateID_CTaxRate2_SCC',
				ctrc2.TaxRate AS 'TaxRate_CTaxRate2_SCC', ctrc2.TaxTypeID AS 'TaxTypeID_CTaxRate2_SCC',
		   ctrm1.CenterID As 'CenterID_CTaxRate1_SCM', ctrm1.CenterTaxRateID AS 'CenterTaxRateID_CTaxRate1_SCM',
				ctrm1.TaxRate AS 'TaxRate_CTaxRate1_SCM', ctrm1.TaxTypeID AS 'TaxTypeID_CTaxRate1_SCM',
		   ctrm2.CenterID As 'CenterID_CTaxRate2_SCM', ctrm2.CenterTaxRateID AS 'CenterTaxRateID_CTaxRate2_SCM',
				ctrm2.TaxRate AS 'TaxRate_CTaxRate2_SCM', ctrm2.TaxTypeID AS 'TaxTypeID_CTaxRate2_SCM',
		   sc.IsBosleySalesCode

	FROM lkpSalesCodeDepartment scd
		  INNER JOIN cfgSalesCode sc ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		  INNER JOIN cfgSalesCodeCenter scc ON sc.SalesCodeID = scc.SalesCodeID
		  INNER JOIN cfgSalesCodeMembership scm ON scc.SalesCodeCenterID = scm.SalesCodeCenterID
		  INNER JOIN datClientMembership cm ON scm.MembershipID = cm.MembershipID
		  Left JOIN lkpBrand lb on sc.BrandID = lb.BrandID
		  LEFT JOIN cfgCenterTaxRate ctrc1 ON scc.TaxRate1ID = ctrc1.CenterTaxRateID
		  LEFT JOIN cfgCenterTaxRate ctrc2 ON scc.TaxRate2ID = ctrc2.CenterTaxRateID
		  LEFT JOIN cfgCenterTaxRate ctrm1 ON scm.TaxRate1ID = ctrm1.CenterTaxRateID
		  LEFT JOIN cfgCenterTaxRate ctrm2 ON scm.TaxRate2ID = ctrm2.CenterTaxRateID
		  LEFT JOIN lkpSalesCodeType sct ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
		  LEFT JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
	where scc.CenterID = @currentCenter
		  AND cm.ClientMembershipGUID = @clientMembershipGuid
		  AND scd.IsActiveFlag = 1
		  AND sc.IsActiveFlag = 1
		  AND scc.IsActiveFlag = 1
		  AND scm.IsActiveFlag = 1
		 -- AND ( cm.IsActiveFlag = 1
		--		OR sct.SalesCodeTypeDescriptionShort = 'Product'
		--		OR sc.SalesCodeDescriptionShort = 'ARREFUND'
		--	)
		  AND sc.CanOrderFlag = 1
		  AND ((@NB1ApplicationOccured = 1 AND sc.salescodeid <> 648) OR @NB1ApplicationOccured = 0) -- If initial application has occured, exclude NB1 sales code.
		  AND sc.IsManagedByClientOnly = 0

END
