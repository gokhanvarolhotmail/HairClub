/* CreateDate: 10/31/2017 23:55:59.313 , ModifyDate: 03/12/2020 12:09:12.133 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmLeadUpsert
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

EXEC extSalesforceToHcmLeadUpsert '00Qf4000004ZZAsEAO', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmLeadUpsert]
(
	@SF_ID NVARCHAR(18),
	@BatchID INT
)
AS
BEGIN

DECLARE	@ContactID NVARCHAR(25)
,		@CenterNumber INT
,		@FirstName NVARCHAR(50)
,		@LastName NVARCHAR(50)
,		@GenderCode NVARCHAR(50)
,		@LanguageCode NVARCHAR(50)
,		@SourceCode NVARCHAR(50)
,		@PromotionCode NVARCHAR(50)
,		@DoNotContact BIT
,		@DoNotCall BIT
,		@DoNotEmail BIT
,		@DoNotMail BIT
,		@DoNotText BIT
,		@StatusCode NVARCHAR(50)
,		@SiebelID NVARCHAR(50)
,		@CreatedBy NVARCHAR(50)
,		@CreateDate DATETIME
,		@UpdatedBy NVARCHAR(50)
,		@UpdateDate DATETIME
,		@OncContactID NVARCHAR(25)
,		@SessionID NVARCHAR(100)
,		@TimezoneCode NVARCHAR(50)


SELECT  @ContactID = shl.contact_id
,       @CenterNumber = ISNULL(ISNULL(shl.CenterID, shl.CenterNumber), '')
,       @FirstName = ISNULL(shl.FirstName, '')
,       @LastName = ISNULL(shl.LastName, '')
,       @GenderCode = CASE WHEN shl.Gender = 'Female' THEN 'Female' ELSE 'Male' END
,       @LanguageCode = ISNULL(shl.LanguageCode, 'ENGLISH')
,       @SourceCode = ISNULL(shl.SourceCode, '!INVALID')
,       @PromotionCode = CASE WHEN LEN(shl.PromotionCode) > 10 THEN 'UNKNOWN' ELSE ISNULL(shl.PromotionCode, 'UNKNOWN') END
,       @DoNotContact = ISNULL(shl.DoNotContact, 0)
,       @DoNotCall = ISNULL(shl.DoNotCall, 0)
,       @DoNotEmail = ISNULL(shl.DoNotEmail, 0)
,       @DoNotMail = ISNULL(shl.DoNotMail, 0)
,       @DoNotText = ISNULL(shl.DoNotText, 0)
,       @StatusCode = CASE WHEN shl.StatusCode NOT IN ( 'Lead', 'Client', 'Invalid', 'Deleted', 'Merged', 'Prospect', 'Event', 'Test', 'HWLead', 'HWClient' ) THEN 'Lead' ELSE shl.StatusCode END
,		@SiebelID = ISNULL(shl.SiebelID, '')
,       @CreatedBy = ISNULL(shu_cb.user_code, shl.SalesforceCreatedByUserId)
,       @CreateDate = shl.SalesforceCreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, shl.SalesforceLastModifiedByUserId)
,       @UpdateDate = shl.SalesforceLastModifiedDate
,		@SessionID = shl.SessionID
,		@TimezoneCode = shl.TimezoneCode
FROM    SFDC_HCM_Lead shl
		INNER JOIN SFDC_HCM_User shu_cb
			ON shu_cb.cst_sfdc_user_id = shl.SalesforceCreatedByUserId
		INNER JOIN SFDC_HCM_User shu_ub
			ON shu_ub.cst_sfdc_user_id = shl.SalesforceLastModifiedByUserId
WHERE   shl.cst_sfdc_lead_id = @SF_ID
		AND shl.BatchID = @BatchID


-- Check for Lead in OnC Table.
IF ISNULL(@ContactID, '') = ''
BEGIN
	SELECT  @OncContactID = oc.contact_id
	FROM    OnContact_oncd_contact_TABLE oc
	WHERE   oc.cst_sfdc_lead_id = @SF_ID
			AND oc.contact_status_code IN ( 'LEAD', 'CLIENT', 'HWLEAD', 'HWCLIENT', 'EVENT', 'PROSPECT' )


	IF ISNULL(@OncContactID, '') <> ''
	BEGIN
		SET @ContactID = @OncContactID

		UPDATE  SFDC_HCM_Lead
		SET     contact_id = @ContactID
		WHERE   cst_sfdc_lead_id = @SF_ID
				AND BatchID = @BatchID
	END
END


-- Create Lead Record.
IF ISNULL(@ContactID, '') = ''
BEGIN
	EXEC OnContact_extSalesforceToHcmCreateLead_PROC
		@ContactID = @ContactID OUTPUT,
		@FirstName = @FirstName,
		@LastName = @LastName,
		@Gender = @GenderCode,
		@Source = @SourceCode,
		@IsDoNotContact = @DoNotContact,
		@IsDoNotCall = @DoNotCall,
		@IsDoNotEmail = @DoNotEmail,
		@IsDoNotMail = @DoNotMail,
		@IsDoNotText = @DoNotText,
		@LanguageCode = @LanguageCode,
		@PromoCode = @PromotionCode,
		@StatusCode = @StatusCode,
		@SiebelID = @SiebelID,
		@TimezoneCode = @TimezoneCode,
		@SessionID = @SessionID,
		@CreateUser = @CreatedBy,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@CenterID = @CenterNumber,
		@SF_ID = @SF_ID


	-- Update Bridge Table with Contact ID.
	IF EXISTS ( SELECT  oc.contact_id
				FROM    OnContact_oncd_contact_TABLE oc
				WHERE   oc.contact_id = @ContactID
						AND oc.cst_sfdc_lead_id = @SF_ID
						AND oc.contact_status_code IN ( 'LEAD', 'CLIENT', 'HWLEAD', 'HWCLIENT', 'EVENT', 'PROSPECT' ) )
	BEGIN
		UPDATE  SFDC_HCM_Lead
		SET     contact_id = @ContactID
		WHERE   cst_sfdc_lead_id = @SF_ID
				AND BatchID = @BatchID


		-- Create Audit Record
		EXEC extSalesforceToHcmAuditRecordInsert
			@BatchID = @BatchID,
			@TableName = 'SFDC_HCM_Lead',
			@SF_ID = @SF_ID,
			@OnContactID = @ContactID,
			@ActionTaken = 'Inserted Record',
			@SortOrder = 2
	END
END

-- Update Lead Record.
ELSE IF ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmUpdateLead_PROC
		@ContactID = @ContactID,
		@FirstName = @FirstName,
		@LastName = @LastName,
		@Gender = @GenderCode,
		@Source = @SourceCode,
		@IsDoNotContact = @DoNotContact,
		@IsDoNotCall = @DoNotCall,
		@IsDoNotEmail = @DoNotEmail,
		@IsDoNotMail = @DoNotMail,
		@IsDoNotText = @DoNotText,
		@LanguageCode = @LanguageCode,
		@PromoCode = @PromotionCode,
		@StatusCode = @StatusCode,
		@SiebelID = @SiebelID,
		@TimezoneCode = @TimezoneCode,
		@SessionID = @SessionID,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@CenterID = @CenterNumber,
		@SF_ID = @SF_ID


	-- Create Audit Record
	EXEC extSalesforceToHcmAuditRecordInsert
		@BatchID = @BatchID,
		@TableName = 'SFDC_HCM_Lead',
		@SF_ID = @SF_ID,
		@OnContactID = @ContactID,
		@ActionTaken = 'Updated Record',
		@SortOrder = 3
END

END
GO
