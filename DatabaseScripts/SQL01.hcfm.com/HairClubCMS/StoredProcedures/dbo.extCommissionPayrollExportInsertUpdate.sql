/* CreateDate: 03/14/2013 10:07:57.277 , ModifyDate: 03/15/2014 09:55:23.017 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionPayrollExportInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert/update payroll export record
==============================================================================
NOTES:
	03/15/14 MVT	Added Transaction to resolve a DTC Error with SQL06
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionPayrollExportInsertUpdate] 'CA', 344
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionPayrollExportInsertUpdate] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
,	@User NVARCHAR(50)
)  AS
BEGIN
	SET NOCOUNT ON

BEGIN TRANSACTION
SET XACT_ABORT ON

	IF NOT EXISTS (
		SELECT ExportID
		FROM Commission_DimPayrollExport_TABLE
		WHERE CountryRegionDescriptionShort = @Country
			AND PayPeriodKey = @PayPeriodKey
	)
		BEGIN
			INSERT INTO Commission_DimPayrollExport_TABLE (
				CountryRegionDescriptionShort
			,	PayPeriodKey
			,	ExportDate
			,	CreateDate
			,	CreateUser
			,	UpdateDate
			,	UpdateUser
			) VALUES (
				@Country
			,	@PayPeriodKey
			,	GETDATE()
			,	GETDATE()
			,	@User
			,	GETDATE()
			,	@User
			)
		END
	ELSE
		BEGIN
			UPDATE Commission_DimPayrollExport_TABLE
			SET ExportDate = GETDATE()
			,	UpdateDate = GETDATE()
			,	UpdateUser = @User
			WHERE CountryRegionDescriptionShort = @Country
				AND PayPeriodKey = @PayPeriodKey
		END

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


SET XACT_ABORT OFF
COMMIT TRANSACTION

END
GO
