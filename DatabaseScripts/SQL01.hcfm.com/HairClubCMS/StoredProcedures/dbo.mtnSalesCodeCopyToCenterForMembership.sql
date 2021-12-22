/*
======================================================================================
PROCEDURE:				mtnSalesCodeCopyToCenterForMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		09/11/2014

LAST REVISION DATE: 	09/11/2014

======================================================================================
DESCRIPTION:	Copies a Sales Code From one to Center to Another, for a Membership
======================================================================================
NOTES:
		* 09/11/2014 SAL - Created Stored Proc
		* 05/18/2015 SAL - Updated SAMPLE EXECUTION comments to indicate that you can
							bulk copy all sales codes for a membership from one center
							to another

======================================================================================
SAMPLE EXECUTION:
EXEC mtnSalesCodeCopyToCenterForMembership 216, 220, 'XTRPROD', 'Xtrand', 'TFS3516'
EXEC mtnSalesCodeCopyToCenterForMembership 216, 220, NULL, 'Xtrand', 'TFS3516' - this will copy ALL sales codes for the membership
======================================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesCodeCopyToCenterForMembership]
		@FromCenterID int,
		@ToCenterID int,
		@SalesCodeDescriptionShort nvarchar(15),
		@MembershipDescriptionShort nvarchar(10),
		@User nvarchar(25)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @SalesCodeID int

	-- Get the SalesCodeID
	SELECT @SalesCodeID = SalesCodeID FrOM cfgSalesCode Where SalesCodeDescriptionShort = @SalesCodeDescriptionShort

	--Insert SalesCodeCenter record, if not already there
	INSERT INTO cfgSalesCodeCenter
				(CenterID
				,SalesCodeID
				,PriceRetail
				,TaxRate1ID
				,TaxRate2ID
				,QuantityOnHand
				,QuantityOnOrdered
				,QuantityTotalSold
				,QuantityMaxLevel
				,QuantityMinLevel
				,IsActiveFlag
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser)
	SELECT @ToCenterID
				,scc.SalesCodeID
				,scc.PriceRetail
				,ToTr1.CenterTaxRateID
				,ToTr2.CenterTaxRateID
				,scc.QuantityOnHand
				,scc.QuantityOnOrdered
				,scc.QuantityTotalSold
				,scc.QuantityMaxLevel
				,scc.QuantityMinLevel
				,scc.IsActiveFlag
				,GETUTCDATE() as CreateDAte
				,@User as CreateUser
				,GETUTCDATE() as LastUpdate
				,@User as LastUpdateUser
	FROM cfgSalesCodeCenter scc
		LEFT OUTER JOIN cfgCenterTaxRate tr1 on scc.TaxRate1ID = tr1.CenterTaxRateID
		LEFT OUTER JOIN cfgCenterTaxRate tr2 on scc.TaxRate2ID = tr2.CenterTaxRateID
		LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
		LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
		LEFT OUTER JOIN cfgSalesCodeCenter sccNew on scc.SalesCodeID = sccNew.SalesCodeID
					AND sccNew.CenterID = @ToCenterID
	WHERE scc.CenterID = @FromCenterID
			AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)
			AND scc.IsActiveFlag = 1
			AND sccNew.SalesCodeCenterID IS NULL --this prevents a duplicate from being inserted into the SalesCodeCenter


	--Insert SalesCodeMembership record, if not already there
	INSERT INTO cfgSalesCodeMembership
				(SalesCodeCenterID
				,MembershipID
				,Price
				,TaxRate1ID
				,TaxRate2ID
				,IsActiveFlag
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser)
	SELECT sccNew.SalesCodeCenterID
				,scm.MembershipID
				,scm.Price
				,ToTr1.CenterTaxRateID
				,ToTr2.CenterTaxRateID
				,scm.IsActiveFlag
				,GETUTCDATE() as CreateDate
				,@User as CreateUser
				,GETUTCDATE() as LastUpdate
				,@User as LastUpateUser
	FROM cfgSalesCodeCenter scc
		INNER JOIN cfgSalesCodeCenter sccNew on sccNew.CenterID = @ToCenterID
						AND sccNew.SalesCodeID = scc.SalesCodeID
		inner join cfgSalesCodeMembership scm on scm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgMembership m on scm.MembershipID = m.MembershipID
		LEFT OUTER JOIN cfgCenterTaxRate tr1 on scm.TaxRate1ID = tr1.CenterTaxRateID
		LEFT OUTER JOIN cfgCenterTaxRate tr2 on scm.TaxRate2ID = tr2.CenterTaxRateID
		LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
		LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
		LEFT OUTER JOIN cfgSalesCodeMembership scmNew on sccNew.SalesCodeCenterID = scmNew.SalesCodeCenterID
						AND scm.MembershipID = scmNew.MembershipID
	WHERE scc.CenterID = @FromCenterID
			AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)  --this prevents it from inserted it its not a valid sales code for the center already
			AND scc.IsActiveFlag = 1
			and m.MembershipDescriptionShort = @MembershipDescriptionShort
			AND scm.IsActiveFlag = 1
			and scmNew.SalesCodeMembershipID IS NULL --this prevents a duplicate from being inserted into the SalesCodeMembership

END
