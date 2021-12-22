/*
==============================================================================
PROCEDURE:				mtnSalesCodeCopyToCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 7/24/2013

LAST REVISION DATE: 	 7/24/2013

==============================================================================
DESCRIPTION:	Copies a Sales Code From one to Center to Another
==============================================================================
NOTES:
		* 07/24/13 MLM - Created Stored Proc
		* 08/20/13 MLM - Fixed cfgSalesCodeMembership
==============================================================================
SAMPLE EXECUTION:
EXEC mtnSalesCodeCopyToCenter 207, 218, NULL
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesCodeCopyToCenter]
		@FromCenterID int
		,@ToCenterID int
		,@SalesCodeDescriptionShort nvarchar(15)

AS
BEGIN
			SET NOCOUNT ON;

			DECLARE @SalesCodeID int

			-- Get the SalesCodeID
			SELECT @SalesCodeID = SalesCodeID FrOM cfgSalesCode Where SalesCodeDescriptionShort = @SalesCodeDescriptionShort



			--Update Existing cfgSalesCodeCenter Records
			Update sccNew
				SET PriceRetail = scc.PriceRetail
					,TaxRate1ID = ToTr1.CenterTaxRateID
					,TaxRate2ID = ToTr2.CenterTaxRateID
					,QuantityOnHand = scc.QuantityOnHand
					,QuantityOnOrdered = scc.QuantityOnOrdered
					,QuantityTotalSold = scc.QuantityTotalSold
					,QuantityMaxLevel = scc.QuantityMaxLevel
					,QuantityMinLevel = scc.QuantityMinLevel
					,IsActiveFlag = scc.IsActiveFlag
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = 'sa'
			 FROM cfgSalesCodeCenter scc
				INNER JOIN cfgSalesCodeCenter sccNew on scc.SalesCodeID = sccNew.SalesCodeID
							AND sccNew.CenterID = @ToCenterID
				LEFT OUTER JOIN cfgCenterTaxRate tr1 on scc.TaxRate1ID = tr1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate tr2 on scc.TaxRate2ID = tr2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
			 Where scc.CenterID = @FromCenterID
				AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)


			 -- Update Existing cfgSalesCodeMembership
			 Update scmNew
				SET Price = scm.Price
					,TaxRate1ID = ToTr1.CenterTaxRateID
					,TaxRate2ID = ToTr2.CenterTaxRateID
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = 'sa'
			 FROM cfgSalesCodeCenter scc
			 	INNER JOIN cfgSalesCodeCenter sccNew on sccNew.CenterID = @ToCenterID
								AND sccNew.SalesCodeID = scc.SalesCodeID
				inner join cfgSalesCodeMembership scm on scm.SalesCodeCenterID = scc.SalesCodeCenterID
				INNER JOIN cfgSalesCodeMembership scmNew on sccNew.SalesCodeCenterID = scmNew.SalesCodeCenterID
								AND scm.MembershipID = scmNew.MembershipID
				LEFT OUTER JOIN cfgCenterTaxRate tr1 on scm.TaxRate1ID = tr1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate tr2 on scm.TaxRate2ID = tr2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
			WHERE scc.CenterID = @FromCenterID
				AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)


			  --Insert Missing cfgSalesCodeCenter Records
			  INSERT INTO cfgSalesCodeCenter( CenterID
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
				,'sa' as CreateUser
				,GETUTCDATE() as LastUpdate
				,'sa' as LastUpdateUser
			 FROM cfgSalesCodeCenter scc
				LEFT OUTER JOIN cfgCenterTaxRate tr1 on scc.TaxRate1ID = tr1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate tr2 on scc.TaxRate2ID = tr2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
				LEFT OUTER JOIN cfgSalesCodeCenter sccNew on scc.SalesCodeID = sccNew.SalesCodeID
							AND sccNew.CenterID = @ToCenterID
			 Where scc.CenterID = @FromCenterID
			 	AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)
				AND sccNew.SalesCodeCenterID IS NULL


			-- Insert Missing cfgSalesCodeMembership
			 INSERT INTO cfgSalesCodeMembership(SalesCodeCenterID
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
				,'sa' as CreateUser
				,GETUTCDATE() as LastUpdate
				,'sa' as LastUpateUser
			 FROM cfgSalesCodeCenter scc
				INNER JOIN cfgSalesCodeCenter sccNew on sccNew.CenterID = @ToCenterID
								AND sccNew.SalesCodeID = scc.SalesCodeID
				inner join cfgSalesCodeMembership scm on scm.SalesCodeCenterID = scc.SalesCodeCenterID
				LEFT OUTER JOIN cfgCenterTaxRate tr1 on scm.TaxRate1ID = tr1.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate tr2 on scm.TaxRate2ID = tr2.CenterTaxRateID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr1 on tr1.TaxTypeID = ToTr1.TaxTypeID AND @ToCenterID = ToTr1.CenterID
				LEFT OUTER JOIN cfgCenterTaxRate ToTr2 on tr2.TaxTypeID = ToTr2.TaxTypeID AND @ToCenterID = ToTr2.CenterID
				LEFT OUTER JOIN cfgSalesCodeMembership scmNew on sccNew.SalesCodeCenterID = scmNew.SalesCodeCenterID
								AND scm.MembershipID = scmNew.MembershipID
			WHERE scc.CenterID = @FromCenterID
					AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)
					and scmNew.SalesCodeMembershipID IS NULL



			--Remove cfgSalesCodeMembership Records Which are not in copied Center
			DELETE FROM cfgSalesCodeMembership WHERE SalesCodeCenterID IN
				 (SELECT scc.SalesCodeCenterID
				 FROM cfgSalesCodeCenter scc
					LEFT OUTER JOIN cfgSalesCodeCenter sccOld on sccOld.CenterID = @FromCenterID
									AND sccOld.SalesCodeID = scc.SalesCodeID
				WHERE scc.CenterID = @ToCenterID
					AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)
					AND sccOld.SalesCodeCenterID IS NULL )


			--Remove cfgSalesCodeCenter records where are not part of copied center
			DELETE FROM cfgSalesCodeCenter WHERE SalesCodeCenterID IN
				 (SELECT scc.SalesCodeCenterID
				 FROM cfgSalesCodeCenter scc
					LEFT OUTER JOIN cfgSalesCodeCenter sccOld on sccOld.CenterID = @FromCenterID
									AND sccOld.SalesCodeID = scc.SalesCodeID
				WHERE scc.CenterID = @ToCenterID
					AND (scc.SalesCodeID = @SalesCodeID OR @SalesCodeID IS NULL)
					AND sccOld.SalesCodeCenterID IS NULL )

END
