/* CreateDate: 11/28/2017 16:29:17.343 , ModifyDate: 11/28/2017 16:29:17.343 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmBatchHeaderInsert
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
RELATED APPLICATION:	Salesforce to HCM Data Sync
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/10/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

DECLARE	@BatchID INT


EXEC extSalesforceToHcmBatchHeaderInsert @BatchID OUTPUT


SELECT	@BatchID AS 'BatchID'
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmBatchHeaderInsert]
(
	@BatchID INT OUTPUT
)
AS
BEGIN

INSERT  INTO SFDC_HCM_Batch
        ( Status, LSET )
VALUES  ( 'Pending Processing', GETDATE() )


SELECT	@BatchID = SCOPE_IDENTITY()

END
GO
