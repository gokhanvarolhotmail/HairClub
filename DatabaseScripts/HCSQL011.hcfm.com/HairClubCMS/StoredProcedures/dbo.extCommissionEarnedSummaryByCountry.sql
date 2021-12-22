/* CreateDate: 03/12/2013 14:01:37.723 , ModifyDate: 07/31/2017 12:25:57.007 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionEarnedSummaryByCountry]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by Country
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionEarnedSummaryByCountry] 'ALL', 512
EXEC [extCommissionEarnedSummaryByCountry] 'US', 512
EXEC [extCommissionEarnedSummaryByCountry] 'CA', 512
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByCountry] (
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)  AS
BEGIN
	SET NOCOUNT ON


	EXEC Commission_extHairClubCMSEarnedSummaryByCountry_PROC @Country, @PayPeriodKey

END
GO
