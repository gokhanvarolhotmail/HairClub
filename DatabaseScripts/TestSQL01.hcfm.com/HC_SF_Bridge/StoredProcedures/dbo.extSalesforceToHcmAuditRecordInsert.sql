/* CreateDate: 11/28/2017 16:55:33.330 , ModifyDate: 11/28/2017 16:55:33.330 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmAuditRecordInsert
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/20/2017
DESCRIPTION:			11/20/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmAuditRecordInsert
***********************************************************************/
CREATE PROCEDURE [dbo].extSalesforceToHcmAuditRecordInsert
(
	@BatchID INT,
	@TableName NVARCHAR(50),
	@SF_ID NVARCHAR(18),
	@OnContactID NCHAR(10) = NULL,
	@ActionTaken NVARCHAR(50),
	@SortOrder INT
)
AS
BEGIN

INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
VALUES  (
			@BatchID
        ,	@TableName
        ,	@SF_ID
		,	@OnContactID
        ,	@ActionTaken
		,	@SortOrder
		)

END
GO
