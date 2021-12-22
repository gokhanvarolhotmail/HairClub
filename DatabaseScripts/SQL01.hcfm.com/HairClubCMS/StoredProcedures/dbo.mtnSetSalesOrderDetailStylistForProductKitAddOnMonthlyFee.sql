/***********************************************************************

PROCEDURE:				mtnSetSalesOrderDetailStylistForProductKitAddOnMonthlyFee

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		06/27/2019

LAST REVISION DATE: 	06/27/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Sets the Stylist (if not alredy set) on sales order details with the Product Kit Add-On Monthly Fee
		sales code to the Stylist from the sales order detail of the Product Kit Add-On Assignment.

		* 06/27/2019	SAL	Created (TFS #12701)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnSetSalesOrderDetailStylistForProductKitAddOnMonthlyFee

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSetSalesOrderDetailStylistForProductKitAddOnMonthlyFee]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		UPDATE sod
		SET Employee2GUID = assignment.Employee2GUID
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = 'Nightly_SetPKAOMFStylist'
		FROM datSalesOrderDetail sod
			inner join cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
			cross apply
						(
						SELECT x_sod.Employee2GUID
						FROM datSalesOrder x_so
							inner join datSalesOrderDetail x_sod on x_so.SalesOrderGUID = x_sod.SalesOrderGUID
							inner join cfgSalesCode x_sc on x_sod.SalesCodeID = x_sc.SalesCodeID
							left join datEmployee x_e on x_sod.Employee2GUID = x_e.EmployeeGUID
						WHERE x_sc.SalesCodeDescriptionShort in ('ADDONPK')
							and x_sod.Employee2GUID IS NOT NULL
							and x_sod.ClientMembershipAddOnID = sod.ClientMembershipAddOnID
						) assignment
		WHERE sc.SalesCodeDescriptionShort in ('EFTFEEADDONPK')
			and sod.Employee2GUID IS NULL

  END TRY
  BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END
