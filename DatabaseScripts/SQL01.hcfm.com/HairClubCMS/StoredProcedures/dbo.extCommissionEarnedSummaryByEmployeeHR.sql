/***********************************************************************
PROCEDURE:				extCommissionEarnedSummaryByEmployeeHR
PURPOSE:				Export pay period details for all centers for Certipay
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/02/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extCommissionEarnedSummaryByEmployeeHR 'ALL', 510
EXEC extCommissionEarnedSummaryByEmployeeHR 'US', 510
EXEC extCommissionEarnedSummaryByEmployeeHR 'CA', 510
***********************************************************************/
CREATE PROCEDURE [dbo].[extCommissionEarnedSummaryByEmployeeHR]
(
	@Country VARCHAR(3),
	@PayPeriodKey INT
)
AS
BEGIN

EXEC Commission_extHairClubCMSEarnedSummaryByEmployeeHR_PROC @Country, @PayPeriodKey

END
