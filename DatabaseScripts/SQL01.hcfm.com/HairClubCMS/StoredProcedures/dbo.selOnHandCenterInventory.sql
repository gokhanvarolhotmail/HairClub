/***********************************************************************

PROCEDURE:				selOnHandCenterInventory

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Alejandro Acevedo

IMPLEMENTOR: 			Alejandro Acevedo

DATE IMPLEMENTED: 		15/10/2020

LAST REVISION DATE: 	15/10/2020

--------------------------------------------------------------------------------------------------------
NOTES:  Return On-Hand Center Inventory

		* 15/10/2020	AAM	Created (TFS #14586)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selOnHandCenterInventory 240

***********************************************************************/

CREATE PROCEDURE [dbo].[selOnHandCenterInventory]
	@CenterID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		SELECT sc.SalesCodeDescription,sc.SalesCodeDescriptionShort,sc.size, sci.QuantityOnHand
		--, scc.CenterCost, 		c.CenterDescription,cs.SizeDescription 'Recurringsize' ,csn.SizeDescription 'Newsize' ,		sci.*
		FROM datsalescodecenterInventory sci
		INNER JOIN cfgsalescodecenter scc on scc. Salescodecenterid = sci.Salescodecenterid
		INNER JOIN cfgSalesCode sc on sc.SalesCodeId = scc.SalesCodeID
		INNER JOIN cfgcenter c on c .centerid = scc.Centerid
		INNER JOIN cfgconfigurationcenter cc on cc.Centerid = c.Centerid
		INNER JOIN lkpSize cs on cc .RecurringBusinessSizeID = cs.SizeId
		INNER JOIN lkpsize csn on cc .NewBusinesssizeID = csn.SizeId
		wHERE scc.centerid = @CenterID --and sc . SalesCodeDescriptionShort = '01-01-08-001 '
		order by sc.SalesCodeDescription asc
  END TRY

  BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END
