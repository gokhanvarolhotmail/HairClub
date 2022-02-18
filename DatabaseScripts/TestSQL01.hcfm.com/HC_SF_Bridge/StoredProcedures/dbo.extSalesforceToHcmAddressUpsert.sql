/* CreateDate: 11/28/2017 16:47:21.010 , ModifyDate: 03/12/2020 11:38:00.643 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmAddressUpsert
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

EXEC extSalesforceToHcmAddressUpsert ''
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmAddressUpsert]
(
	@SF_ID NVARCHAR(18),
	@BatchID INT
)
AS
BEGIN

DECLARE	@SF_Lead_ID NVARCHAR(18)
,		@ContactAddressID NCHAR(10)
,		@ContactID NCHAR(10)
,		@AddressLine1 VARCHAR(100)
,		@AddressLine2 VARCHAR(100)
,		@City VARCHAR(50)
,		@StateCode VARCHAR(50)
,		@Zip VARCHAR(50)
,		@Country VARCHAR(50)
,		@IsPrimaryFlag BIT
,		@CreatedBy VARCHAR(50)
,		@CreateDate DATETIME
,		@UpdatedBy VARCHAR(50)
,		@UpdateDate DATETIME
,		@OncContactAddressID VARCHAR(25)


SELECT  @SF_Lead_ID = shla.cst_sfdc_lead_id
,       @ContactAddressID = shla.contact_address_id
,       @ContactID = ISNULL(shla.contact_id, shl.contact_id)
,       @AddressLine1 = shla.Address1
,       @AddressLine2 = shla.Address2
,       @City = shla.City
,       @StateCode = shla.StateCode
,       @Zip = shla.ZipCode
,       @Country = ISNULL(oc.country_code, 'US')
,       @IsPrimaryFlag = ISNULL(shla.IsPrimaryFlag, 0)
,       @CreatedBy = ISNULL(shu_cb.user_code, shla.SalesforceCreatedByUserId)
,       @CreateDate = shla.SalesforceCreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, shla.SalesforceLastModifiedByUserId)
,       @UpdateDate = shla.SalesforceLastModifiedDate
FROM    SFDC_HCM_LeadAddress shla
		INNER JOIN SFDC_HCM_Lead shl
			ON shl.cst_sfdc_lead_id = shla.cst_sfdc_lead_id
				AND shl.BatchID = @BatchID
		INNER JOIN SFDC_HCM_User shu_cb
			ON shu_cb.cst_sfdc_user_id = shla.SalesforceCreatedByUserId
		INNER JOIN SFDC_HCM_User shu_ub
			ON shu_ub.cst_sfdc_user_id = shla.SalesforceLastModifiedByUserId
		LEFT OUTER JOIN OnContact_onca_country_TABLE oc
			ON oc.country_name = shla.CountryCode
WHERE   shla.cst_sfdc_address_id = @SF_ID
		AND shla.BatchID = @BatchID


-- Check for Lead Address in OnC Table.
IF ISNULL(@ContactAddressID, '') = ''
BEGIN
	SELECT  @OncContactAddressID = oca.contact_address_id
	FROM    OnContact_oncd_contact_address_TABLE oca
	WHERE   oca.cst_sfdc_leadaddress_id = @SF_ID


	IF ISNULL(@OncContactAddressID, '') <> ''
	BEGIN
		SET @ContactAddressID = @OncContactAddressID

		UPDATE  SFDC_HCM_LeadAddress
		SET     contact_address_id = @ContactAddressID
		WHERE   cst_sfdc_address_id = @SF_ID
				AND BatchID = @BatchID
	END
END


IF ISNULL(@ContactID, '') = ''
BEGIN
    UPDATE  SFDC_HCM_LeadAddress
    SET     IsExcludedFlag = 1
	,		ExclusionMessage = 'Unable to create Lead Address record because we are unable to find the Lead Contact ID.'
    WHERE   cst_sfdc_address_id = @SF_ID
			AND BatchID = @BatchID
END


-- Create Lead Address Record.
IF ISNULL(@ContactAddressID, '') = '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmCreateLeadAddress_PROC
		@ContactAddressID = @ContactAddressID OUTPUT,
		@ContactID = @ContactID,
		@AddressLine1 = @AddressLine1,
		@AddressLine2 = @AddressLine2,
		@City = @City,
		@State = @StateCode,
		@Zip = @Zip,
		@Country = @Country,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@CreateUser = @CreatedBy,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Update Bridge Table with Contact Email ID.
	IF EXISTS ( SELECT  oca.contact_address_id
				FROM    OnContact_oncd_contact_address_TABLE oca
				WHERE   oca.contact_address_id = @ContactAddressID
						AND oca.cst_sfdc_leadaddress_id = @SF_ID )
	BEGIN
		UPDATE  SFDC_HCM_LeadAddress
		SET     contact_address_id = @ContactAddressID
		WHERE   cst_sfdc_address_id = @SF_ID
				AND BatchID = @BatchID


		-- Create Audit Record
		EXEC extSalesforceToHcmAuditRecordInsert
			@BatchID = @BatchID,
			@TableName = 'SFDC_HCM_LeadAddress',
			@SF_ID = @SF_ID,
			@OnContactID = @ContactAddressID,
			@ActionTaken = 'Inserted Record',
			@SortOrder = 2
	END
END

-- Update Lead Address Record.
ELSE IF ISNULL(@ContactAddressID, '') <> '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	EXEC OnContact_extSalesforceToHcmUpdateLeadAddress_PROC
		@ContactAddressID = @ContactAddressID,
		@ContactID = @ContactID,
		@AddressLine1 = @AddressLine1,
		@AddressLine2 = @AddressLine2,
		@City = @City,
		@State = @StateCode,
		@Zip = @Zip,
		@Country = @Country,
		@IsPrimaryFlag = @IsPrimaryFlag,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@SF_ID = @SF_ID


	-- Create Audit Record
	EXEC extSalesforceToHcmAuditRecordInsert
		@BatchID = @BatchID,
		@TableName = 'SFDC_HCM_LeadAddress',
		@SF_ID = @SF_ID,
		@OnContactID = @ContactAddressID,
		@ActionTaken = 'Updated Record',
		@SortOrder = 3
END

END
GO
