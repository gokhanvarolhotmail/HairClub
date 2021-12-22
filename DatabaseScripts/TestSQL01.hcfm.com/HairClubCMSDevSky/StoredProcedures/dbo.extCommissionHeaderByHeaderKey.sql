/* CreateDate: 03/04/2013 22:33:52.957 , ModifyDate: 03/04/2013 22:33:52.957 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionHeaderByHeaderKey]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Mike Maass

==============================================================================
DESCRIPTION:	Commission Header by CommissionHeaderKey
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionHeaderByHeaderKey] 7252
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionHeaderByHeaderKey] (
	@CommissionHeaderKey INT
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT FCH.MembershipDescription
		,ISNULL(FCH.AdvancedCommission, 0) AS 'Commission'
	FROM Commission_FactCommissionHeader_TABLE FCH
	WHERE FCH.CommissionHeaderKey = @CommissionHeaderKey

END
GO
