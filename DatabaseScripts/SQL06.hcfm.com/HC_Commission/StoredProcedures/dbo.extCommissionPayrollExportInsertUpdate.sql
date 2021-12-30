/* CreateDate: 03/14/2013 09:30:39.467 , ModifyDate: 03/14/2013 09:30:43.740 */
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
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionPayrollExportInsertUpdate] 'CA', 344
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionPayrollExportInsertUpdate] (
	@Country CHAR(2)
,	@PayPeriodKey INT
,	@User NVARCHAR(50)
)  AS
BEGIN
	SET NOCOUNT ON


	IF NOT EXISTS (
		SELECT ExportID
		FROM DimPayrollExport
		WHERE CountryRegionDescriptionShort = @Country
			AND PayPeriodKey = @PayPeriodKey
	)
		BEGIN
			INSERT INTO DimPayrollExport (
				CountryRegionDescriptionShort
			,	PayPeriodKey
			,	CreateDate
			,	CreateUser
			,	UpdateDate
			,	UpdateUser
			) VALUES (
				@Country
			,	@PayPeriodKey
			,	GETDATE()
			,	@User
			,	GETDATE()
			,	@User
			)
		END
	ELSE
		BEGIN
			UPDATE DimPayrollExport
			SET UpdateDate = GETDATE()
			,	UpdateUser = @User
			WHERE CountryRegionDescriptionShort = @Country
				AND PayPeriodKey = @PayPeriodKey
		END
END
GO
