/* CreateDate: 11/28/2017 16:49:11.083 , ModifyDate: 03/12/2020 11:38:47.910 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmEmailUpsert
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/27/2017
DESCRIPTION:			10/27/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmEmailUpsert '', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmEmailUpsert]
(
	@SF_ID NVARCHAR(18),
	@BatchID INT
)
AS
BEGIN

DECLARE	@SF_Lead_ID NVARCHAR(18)
,		@ContactEmailID NCHAR(10)
,		@ContactID NCHAR(10)
,		@EmailAddress VARCHAR(100)
,		@IsPrimaryFlag BIT
,		@CreatedBy VARCHAR(50)
,		@CreateDate DATETIME
,		@UpdatedBy VARCHAR(50)
,		@UpdateDate DATETIME
,		@OncContactEmailID VARCHAR(25)


SELECT  @SF_Lead_ID = shle.cst_sfdc_lead_id
,       @ContactEmailID = shle.contact_email_id
,       @ContactID = ISNULL(shle.contact_id, shl.contact_id)
,       @EmailAddress = shle.EmailAddress
,       @IsPrimaryFlag = ISNULL(shle.IsPrimaryFlag, 0)
,       @CreatedBy = ISNULL(shu_cb.user_code, shle.SalesforceCreatedByUserId)
,       @CreateDate = shle.SalesforceCreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, shle.SalesforceLastModifiedByUserId)
,       @UpdateDate = shle.SalesforceLastModifiedDate
FROM    SFDC_HCM_LeadEmail shle
		INNER JOIN SFDC_HCM_Lead shl
			ON shl.cst_sfdc_lead_id = shle.cst_sfdc_lead_id
				AND shl.BatchID = @BatchID
		INNER JOIN SFDC_HCM_User shu_cb
			ON shu_cb.cst_sfdc_user_id = shle.SalesforceCreatedByUserId
		INNER JOIN SFDC_HCM_User shu_ub
			ON shu_ub.cst_sfdc_user_id = shle.SalesforceLastModifiedByUserId
WHERE   shle.cst_sfdc_email_id = @SF_ID
		AND shle.BatchID = @BatchID


-- Check for Lead Email in OnC Table.
IF ISNULL(@ContactEmailID, '') = ''
BEGIN
	SELECT  @OncContactEmailID = oce.contact_email_id
	FROM    OnContact_oncd_contact_email_TABLE oce
	WHERE   oce.cst_sfdc_leademail_id = @SF_ID


	IF ISNULL(@OncContactEmailID, '') <> ''
	BEGIN
		SET @ContactEmailID = @OncContactEmailID

		UPDATE  SFDC_HCM_LeadEmail
		SET     contact_email_id = @ContactEmailID
		WHERE   cst_sfdc_email_id = @SF_ID
				AND BatchID = @BatchID
	END
END


IF ISNULL(@ContactID, '') = ''
BEGIN
    UPDATE  SFDC_HCM_LeadEmail
    SET     IsExcludedFlag = 1
	,		ExclusionMessage = 'Unable to create Lead Email record because we are unable to find the Lead Contact ID.'
    WHERE   cst_sfdc_email_id = @SF_ID
			AND BatchID = @BatchID
END


-- Create Lead Email Record.
IF ISNULL(@ContactEmailID, '') = '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmCreateLeadEmail_PROC
		@ContactEmailID = @ContactEmailID OUTPUT,
		@ContactID = @ContactID,
		@EmailAddress = @EmailAddress,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@CreateUser = @CreatedBy,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Update Bridge Table with Contact Email ID.
	IF EXISTS ( SELECT  oce.contact_email_id
				FROM    OnContact_oncd_contact_email_TABLE oce
				WHERE   oce.contact_email_id = @ContactEmailID
						AND oce.cst_sfdc_leademail_id = @SF_ID )
	BEGIN
		UPDATE  SFDC_HCM_LeadEmail
		SET     contact_email_id = @ContactEmailID
		WHERE   cst_sfdc_email_id = @SF_ID
				AND BatchID = @BatchID


		-- Create Audit Record
		EXEC extSalesforceToHcmAuditRecordInsert
			@BatchID = @BatchID,
			@TableName = 'SFDC_HCM_LeadEmail',
			@SF_ID = @SF_ID,
			@OnContactID = @ContactEmailID,
			@ActionTaken = 'Inserted Record',
			@SortOrder = 2
	END
END

-- Update Lead Email Record.
ELSE IF ISNULL(@ContactEmailID, '') <> '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmUpdateLeadEmail_PROC
		@ContactEmailID = @ContactEmailID,
		@ContactID = @ContactID,
		@EmailAddress = @EmailAddress,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Create Audit Record
	EXEC extSalesforceToHcmAuditRecordInsert
		@BatchID = @BatchID,
		@TableName = 'SFDC_HCM_LeadEmail',
		@SF_ID = @SF_ID,
		@OnContactID = @ContactEmailID,
		@ActionTaken = 'Updated Record',
		@SortOrder = 3
END

END
GO
