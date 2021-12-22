/* CreateDate: 03/14/2013 10:06:55.427 , ModifyDate: 07/02/2017 15:56:15.287 */
GO
/***********************************************************************
PROCEDURE:				extCommissionHRAuditByCountryAndPayPeriod
PURPOSE:				Export pay period details for all US centers for Certipay
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/02/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extCommissionHRAuditByCountryAndPayPeriod 'ALL', 510
EXEC extCommissionHRAuditByCountryAndPayPeriod 'US', 510
EXEC extCommissionHRAuditByCountryAndPayPeriod 'CA', 510
***********************************************************************/
CREATE PROCEDURE [dbo].[extCommissionHRAuditByCountryAndPayPeriod]
(
	@Country VARCHAR(3),
	@PayPeriodKey INT
)
AS
BEGIN

EXEC Commission_extHairClubCMSHRAuditByCountryAndPayPeriod_PROC @Country, @PayPeriodKey

END
GO
