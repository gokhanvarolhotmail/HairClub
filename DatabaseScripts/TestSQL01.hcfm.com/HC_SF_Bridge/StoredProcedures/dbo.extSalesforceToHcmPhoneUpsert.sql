/* CreateDate: 11/28/2017 16:51:30.557 , ModifyDate: 03/12/2020 11:38:12.320 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmPhoneUpsert
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

EXEC extSalesforceToHcmPhoneUpsert '', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmPhoneUpsert]
(
	@SF_ID NVARCHAR(18),
	@BatchID INT
)
AS
BEGIN

DECLARE	@SF_Lead_ID NVARCHAR(18)
,		@ContactPhoneID NCHAR(10)
,		@ContactID NCHAR(10)
,		@AreaCode NVARCHAR(50)
,		@PhoneNumber NVARCHAR(50)
,		@DoNotCall BIT
,		@DoNotText BIT
,		@DNCFlag BIT
,		@DNCDate DATETIME
,		@EBRDNC BIT
,		@EBRDNCDate DATETIME
,		@IsWirelessFlag BIT
,		@WirelessDate DATETIME
,		@IsPrimaryFlag BIT
,		@SortOrder INT
,		@PhoneType NVARCHAR(50)
,		@StatusCode NVARCHAR(50)
,		@IsValidFlag BIT
,		@CreatedBy VARCHAR(50)
,		@CreateDate DATETIME
,		@UpdatedBy VARCHAR(50)
,		@UpdateDate DATETIME
,		@OncContactPhoneID VARCHAR(25)


SELECT  @SF_Lead_ID = shlp.cst_sfdc_lead_id
,       @ContactPhoneID = shlp.contact_phone_id
,       @ContactID = ISNULL(shlp.contact_id, shl.contact_id)
,		@AreaCode = CASE WHEN LEN(shlp.PhoneNumberUnformatted) = 10 THEN LEFT(shlp.PhoneNumberUnformatted, 3) ELSE ISNULL(shlp.AreaCode, '') END
,		@PhoneNumber = CASE WHEN LEN(shlp.PhoneNumberUnformatted) = 10 THEN SUBSTRING(shlp.PhoneNumberUnformatted, 4, 3) + SUBSTRING(shlp.PhoneNumberUnformatted, 7, 4) ELSE ISNULL(shlp.PhoneNumber, shlp.PhoneNumberUnformatted) END
,		@DoNotCall = ISNULL(shlp.DoNotCall, 0)
,		@DoNotText = ISNULL(shlp.DoNotText, 0)
,		@DNCFlag = ISNULL(shlp.DNCFlag, 0)
,		@DNCDate = ISNULL(shlp.DNCDate, GETDATE())
,		@EBRDNC = ISNULL(shlp.EBRDNC, 0)
,		@EBRDNCDate = ISNULL(shlp.EBRDNCDate, GETDATE())
,		@IsWirelessFlag = ISNULL(shlp.IsWirelessFlag, 0)
,		@WirelessDate = ISNULL(shlp.WirelessDate, GETDATE())
,		@IsPrimaryFlag = ISNULL(shlp.IsPrimaryFlag, 0)
,       @SortOrder = ISNULL(shlp.SortOrder, 0)
,       @PhoneType = UPPER(REPLACE(shlp.PhoneType, ' ', ''))
,		@StatusCode = shl.StatusCode
,		@IsValidFlag = ISNULL(shlp.IsValidFlag, 0)
,       @CreatedBy = ISNULL(shu_cb.user_code, shlp.SalesforceCreatedByUserId)
,       @CreateDate = shlp.SalesforceCreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, shlp.SalesforceLastModifiedByUserId)
,       @UpdateDate = shlp.SalesforceLastModifiedDate
FROM    SFDC_HCM_LeadPhone shlp
		INNER JOIN SFDC_HCM_Lead shl
			ON shl.cst_sfdc_lead_id = shlp.cst_sfdc_lead_id
				AND shl.BatchID = @BatchID
		INNER JOIN SFDC_HCM_User shu_cb
			ON shu_cb.cst_sfdc_user_id = shlp.SalesforceCreatedByUserId
		INNER JOIN SFDC_HCM_User shu_ub
			ON shu_ub.cst_sfdc_user_id = shlp.SalesforceLastModifiedByUserId
WHERE   shlp.cst_sfdc_phone_id = @SF_ID
		AND shlp.BatchID = @BatchID


-- Check for Lead Phone in OnC Table.
IF ISNULL(@ContactPhoneID, '') = ''
BEGIN
	SELECT  @OncContactPhoneID = ocp.contact_phone_id
	FROM    OnContact_oncd_contact_phone_TABLE ocp
	WHERE   ocp.cst_sfdc_leadphone_id = @SF_ID


	IF ISNULL(@OncContactPhoneID, '') <> ''
	BEGIN
		SET @ContactPhoneID = @OncContactPhoneID

		UPDATE  SFDC_HCM_LeadPhone
		SET     contact_phone_id = @ContactPhoneID
		WHERE   cst_sfdc_phone_id = @SF_ID
				AND BatchID = @BatchID
	END
END


IF ISNULL(@ContactID, '') = ''
BEGIN
    UPDATE  SFDC_HCM_LeadPhone
    SET     IsExcludedFlag = 1
	,		ExclusionMessage = 'Unable to create Phone record because we are unable to find the Lead Contact ID.'
    WHERE   cst_sfdc_phone_id = @SF_ID
			AND BatchID = @BatchID
END


-- Create Lead Phone Record.
IF ISNULL(@ContactPhoneID, '') = '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmCreateLeadPhone_PROC
		@ContactPhoneID = @ContactPhoneID OUTPUT,
		@ContactID = @ContactID,
		@AreaCode = @AreaCode,
		@PhoneNumber = @PhoneNumber,
		@IsDoNotCall = @DoNotCall,
		@IsDoNotText = @DoNotText,
		@IsDNCFlag = @DNCFlag,
		@DNCDate = @DNCDate,
		@IsEBRDNC = @EBRDNC,
		@EBRDNCDate = @EBRDNCDate,
		@IsWirelessFlag = @IsWirelessFlag,
		@WirelessDate = @WirelessDate,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@SortOrder = @SortOrder,
		@PhoneType = @PhoneType,
		@IsValidFlag = @IsValidFlag,
		@CreateUser = @CreatedBy,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Update Bridge Table with Lead Phone ID.
	IF EXISTS ( SELECT  ocp.contact_phone_id
				FROM    OnContact_oncd_contact_phone_TABLE ocp
				WHERE   ocp.contact_phone_id = @ContactPhoneID
						AND ocp.cst_sfdc_leadphone_id = @SF_ID )
	BEGIN
		UPDATE  SFDC_HCM_LeadPhone
		SET     contact_phone_id = @ContactPhoneID
		WHERE   cst_sfdc_phone_id = @SF_ID
				AND BatchID = @BatchID


		-- Create Audit Record
		EXEC extSalesforceToHcmAuditRecordInsert
			@BatchID = @BatchID,
			@TableName = 'SFDC_HCM_LeadPhone',
			@SF_ID = @SF_ID,
			@OnContactID = @ContactPhoneID,
			@ActionTaken = 'Inserted Record',
			@SortOrder = 2
	END
END

-- Update Lead Phone Record.
ELSE IF ISNULL(@ContactPhoneID, '') <> '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmUpdateLeadPhone_PROC
		@ContactPhoneID = @ContactPhoneID,
		@ContactID = @ContactID,
		@AreaCode = @AreaCode,
		@PhoneNumber = @PhoneNumber,
		@IsDoNotCall = @DoNotCall,
		@IsDoNotText = @DoNotText,
		@IsDNCFlag = @DNCFlag,
		@DNCDate = @DNCDate,
		@IsEBRDNC = @EBRDNC,
		@EBRDNCDate = @EBRDNCDate,
		@IsWirelessFlag = @IsWirelessFlag,
		@WirelessDate = @WirelessDate,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@SortOrder = @SortOrder,
		@PhoneType = @PhoneType,
		@IsValidFlag = @IsValidFlag,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Create Audit Record
	EXEC extSalesforceToHcmAuditRecordInsert
		@BatchID = @BatchID,
		@TableName = 'SFDC_HCM_LeadPhone',
		@SF_ID = @SF_ID,
		@OnContactID = @ContactPhoneID,
		@ActionTaken = 'Updated Record',
		@SortOrder = 3
END

END
GO
