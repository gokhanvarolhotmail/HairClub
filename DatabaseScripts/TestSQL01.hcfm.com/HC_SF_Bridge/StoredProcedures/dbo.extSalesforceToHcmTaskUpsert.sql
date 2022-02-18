/* CreateDate: 11/01/2017 00:40:09.467 , ModifyDate: 03/12/2020 14:36:12.557 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmTaskUpsert
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

EXEC extSalesforceToHcmTaskUpsert '', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmTaskUpsert]
(
	@SF_ID NVARCHAR(18),
	@BatchID INT
)
AS
BEGIN

DECLARE @ActivityID VARCHAR(25)
,		@WhoId NVARCHAR(18)
,		@ContactID VARCHAR(50)
,		@CenterNumber VARCHAR(50)
,		@ActionCode VARCHAR(50)
,		@ResultCode VARCHAR(50) = NULL
,		@ActivityTypeCode VARCHAR(50)
,		@Description VARCHAR(50)
,		@DueDate DATETIME
,		@StartTime DATETIME
,		@CompletionDate DATETIME = NULL
,		@CompletionTime DATETIME = NULL
,		@CompletedBy VARCHAR(50) = NULL
,		@GenderCode VARCHAR(50)
,		@Birthday VARCHAR(50)
,		@OccupationCode INT
,		@EthnicityCode INT
,		@MaritalStatusCode INT
,		@NorwoodCode VARCHAR(50)
,		@LudwigCode VARCHAR(50)
,		@Age INT
,		@Performer VARCHAR(50)
,		@PriceQuoted MONEY
,		@SolutionOffered VARCHAR(100)
,		@NoSaleReason VARCHAR(200)
,		@DISCStyleCode VARCHAR(1)
,		@SaleTypeCode NVARCHAR(50)
,		@SaleType NVARCHAR(50)
,		@SourceCode VARCHAR(50)
,		@PromoCode VARCHAR(50)
,		@TimeZoneCode VARCHAR(4)
,		@CreatedBy VARCHAR(50)
,		@CreateDate DATETIME
,		@UpdatedBy VARCHAR(50)
,		@UpdateDate DATETIME
,		@OncActivityID VARCHAR(25)
,		@OncContactID VARCHAR(25)
,		@OncCenterNumber VARCHAR(50)


SELECT  @ActivityID = shlt.activity_id
,		@WhoId = shlt.cst_sfdc_lead_id
,		@ContactID = shlt.contact_id
,		@CenterNumber = ISNULL(ISNULL(shlt.CenterID, shlt.CenterNumber), '')
,		@ActionCode = shac.OnContact_ActionCode
,		@ResultCode = shrc.OnContact_ResultCode
,		@ActivityTypeCode = shlt.ActivityTypeCode
,		@Description = shlt.ActionCode
,		@DueDate = CONVERT(VARCHAR(11), CAST(shlt.DueDate AS DATE), 101)
,		@StartTime = CONVERT(VARCHAR(15), CAST(shlt.StartTime AS TIME), 100)
,		@CompletionDate = CASE WHEN shlt.ResultCode IS NULL THEN NULL ELSE CONVERT(VARCHAR(11), CAST(shlt.CompletionDate AS DATE), 101) END
,		@CompletionTime = CASE WHEN shlt.ResultCode IS NULL THEN NULL ELSE CONVERT(VARCHAR(15), CAST(shlt.CompletionDate AS TIME), 100) END
,		@CompletedBy = CASE WHEN shlt.ResultCode IS NULL THEN NULL ELSE ISNULL(shu_cbu.user_code, 'TM6100') END
,		@GenderCode = shlt.Gender
,		@Birthday = ISNULL(CONVERT(VARCHAR(11), CAST(shlt.Birthday AS DATE), 101), '')
,		@OccupationCode = ISNULL(lo.BOSOccupationCode, '0')
,		@EthnicityCode = ISNULL(le.BOSEthnicityCode, '0')
,		@MaritalStatusCode = ISNULL(ms.BOSMaritalStatusCode, '0')
,		@NorwoodCode = ISNULL(ns.NorwoodScaleDescription, 'Unknown')
,		@LudwigCode = ISNULL(ls.LudwigScaleDescription, 'Unknown')
,		@Age = shlt.Age
,		@Performer = shlt.Performer
,		@PriceQuoted = ISNULL(shlt.PriceQuoted, 0.00)
,		@SolutionOffered = shlt.SolutionOffered
,		@NoSaleReason = shlt.NoSaleReason
,		@DISCStyleCode = ISNULL(ds.DISCStyleDescriptionShort, 'x')
,		@SaleTypeCode = shlt.SaleTypeCode
,		@SaleType = shlt.SaleTypeDescription
,		@SourceCode = shlt.SourceCode
,		@PromoCode = shlt.PromotionCode
,		@TimeZoneCode = shlt.Timezone
,       @CreatedBy = ISNULL(shu_cb.user_code, shlt.SalesforceCreatedByUserId)
,       @CreateDate = shlt.SalesforceCreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, shlt.SalesforceLastModifiedByUserId)
,       @UpdateDate = shlt.SalesforceLastModifiedDate
FROM    SFDC_HCM_LeadTask shlt
        INNER JOIN SFDC_HCM_User shu_cb
            ON shu_cb.cst_sfdc_user_id = shlt.SalesforceCreatedByUserId
        INNER JOIN SFDC_HCM_User shu_ub
            ON shu_ub.cst_sfdc_user_id = shlt.SalesforceLastModifiedByUserId
        LEFT OUTER JOIN SFDC_HCM_User shu_cbu
            ON shu_cbu.cst_sfdc_user_id = shlt.SalesforceAssignedToUserId
        LEFT OUTER JOIN SFDC_HCM_ActionCode shac
            ON shac.SF_ActionCode = shlt.ActionCode
				AND shac.IsActiveFlag = 1
        LEFT OUTER JOIN SFDC_HCM_ResultCode shrc
            ON shrc.SF_ResultCode = shlt.ResultCode
				AND shrc.IsActiveFlag = 1
        LEFT OUTER JOIN HairClubCMS_lkpNorwoodScale_TABLE ns
            ON ns.NorwoodScaleDescription = shlt.Norwood
        LEFT OUTER JOIN HairClubCMS_lkpLudwigScale_TABLE ls
            ON ls.LudwigScaleDescription = shlt.Ludwig
        LEFT OUTER JOIN HairClubCMS_lkpMaritalStatus_TABLE ms
            ON ms.MaritalStatusDescription = shlt.MaritalStatus
        LEFT OUTER JOIN HairClubCMS_lkpOccupation_TABLE lo
            ON lo.OccupationDescription = shlt.Occupation
        LEFT OUTER JOIN HairClubCMS_lkpEthnicity_TABLE le
            ON le.EthnicityDescription = shlt.Ethnicity
        LEFT OUTER JOIN HairClubCMS_lkpDISCStyle_TABLE ds
            ON ds.DISCStyleDescription = shlt.DISC
WHERE   shlt.cst_sfdc_task_id = @SF_ID
		AND shlt.BatchID = @BatchID


-- Check for Task in OnC Table.
IF ISNULL(@ActivityID, '') = ''
BEGIN
	SELECT  @OncActivityID = oa.activity_id
	FROM    OnContact_oncd_activity_TABLE oa
	WHERE   oa.cst_sfdc_task_id = @SF_ID


	IF ISNULL(@OncActivityID, '') <> ''
	BEGIN
		SET @ActivityID = @OncActivityID

		UPDATE  SFDC_HCM_LeadTask
		SET     activity_id = @ActivityID
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID
	END
END


IF ISNULL(@ContactID, '') = ''
BEGIN
	SELECT  @OncContactID = l.contact_id
	FROM    HC_SF_Bridge.dbo.SFDC_HCM_Lead l
	WHERE   l.cst_sfdc_lead_id = @WhoId
			AND l.BatchID = @BatchID


	IF ISNULL(@OncContactID, '') <> ''
	BEGIN
		SET @ContactID = @OncContactID

		UPDATE  SFDC_HCM_LeadTask
		SET     contact_id = @ContactID
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID
	END
	ELSE
	BEGIN
		UPDATE  SFDC_HCM_LeadTask
		SET     IsExcludedFlag = 1
		,		ExclusionMessage = 'Unable to create Activity because we are unable to find the Lead Contact ID.'
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID
	END
END


IF ISNULL(@CenterNumber, '') = ''
BEGIN
	SELECT  @OncCenterNumber = ISNULL(l.CenterNumber, l.CenterID)
	FROM    HC_SF_Bridge.dbo.SFDC_HCM_Lead l
	WHERE   l.cst_sfdc_lead_id = @WhoId
			AND l.BatchID = @BatchID


	IF ISNULL(@OncCenterNumber, '') <> ''
	BEGIN
		SET @CenterNumber = @OncCenterNumber

		UPDATE  SFDC_HCM_LeadTask
		SET     CenterNumber = @CenterNumber
		,		CenterID = @CenterNumber
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID
	END
	ELSE
	BEGIN
		UPDATE  SFDC_HCM_LeadTask
		SET     IsExcludedFlag = 1
		,		ExclusionMessage = 'Unable to create Activity because it does not have a Center ID.'
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID
	END
END


-- Create Activity Record.
IF ISNULL(@ActivityID, '') = '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	PRINT 'Created Activity for Task ' + @SF_ID

	EXEC OnContact_extSalesforceToHcmCreateActivity_PROC
		@ActivityID = @ActivityID OUTPUT,
		@ContactID = @ContactID,
		@ActionCode = @ActionCode,
		@ResultCode = @ResultCode,
		@ActivityType = @ActivityTypeCode,
		@Description = @Description,
		@DueDate = @DueDate,
		@StartTime = @StartTime,
		@CompletionDate = @CompletionDate,
		@CompletionTime = @CompletionTime,
		@CompletedByUser = @CompletedBy,
		@Gender = @GenderCode,
		@Birthday = @Birthday,
		@OccupationCode = @OccupationCode,
		@EthnicityCode = @EthnicityCode,
		@MaritalStatusCode = @MaritalStatusCode,
		@Norwood = @NorwoodCode,
		@Ludwig = @LudwigCode,
		@Age = @Age,
		@Performer = @Performer,
		@PriceQuoted = @PriceQuoted,
		@SolutionOffered = @SolutionOffered,
		@NoSaleReason = @NoSaleReason,
		@DISCStyle = @DISCStyleCode,
		@SaleTypeCode = @SaleTypeCode,
		@SaleType = @SaleType,
		@CenterNumber = @CenterNumber,
		@CreateUser = @CreatedBy,
		@CreateDate = @CreateDate,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@ActivitySource = @SourceCode,
		@ActivityPromo = @PromoCode,
		@TimeZoneCode = @TimeZoneCode,
		@SF_ID = @SF_ID


	-- Update Bridge Table with Activity ID.
	IF EXISTS ( SELECT  oa.activity_id
				FROM    OnContact_oncd_activity_TABLE oa
				WHERE   oa.activity_id = @ActivityID
						AND oa.cst_sfdc_task_id = @SF_ID )
	BEGIN
		UPDATE  SFDC_HCM_LeadTask
		SET     activity_id = @ActivityID
		WHERE   cst_sfdc_task_id = @SF_ID
				AND BatchID = @BatchID


		-- Create Audit Record
		EXEC extSalesforceToHcmAuditRecordInsert
			@BatchID = @BatchID,
			@TableName = 'SFDC_HCM_LeadTask',
			@SF_ID = @SF_ID,
			@OnContactID = @ActivityID,
			@ActionTaken = 'Inserted Record',
			@SortOrder = 2
	END
END

-- Update Activity Record.
ELSE IF ISNULL(@ActivityID, '') <> '' AND ISNULL(@ContactID, '') <> ''
BEGIN
	PRINT 'Updated Activity for Task ' + @SF_ID

	EXEC OnContact_extSalesforceToHcmUpdateActivity_PROC
		@ActivityID = @ActivityID,
		@ContactID = @ContactID,
		@ActionCode = @ActionCode,
		@ResultCode = @ResultCode,
		@ActivityType = @ActivityTypeCode,
		@Description = @Description,
		@DueDate = @DueDate,
		@StartTime = @StartTime,
		@CompletionDate = @CompletionDate,
		@CompletionTime = @CompletionTime,
		@CompletedByUser = @CompletedBy,
		@Gender = @GenderCode,
		@Birthday = @Birthday,
		@OccupationCode = @OccupationCode,
		@EthnicityCode = @EthnicityCode,
		@MaritalStatusCode = @MaritalStatusCode,
		@Norwood = @NorwoodCode,
		@Ludwig = @LudwigCode,
		@Age = @Age,
		@Performer = @Performer,
		@PriceQuoted = @PriceQuoted,
		@SolutionOffered = @SolutionOffered,
		@NoSaleReason = @NoSaleReason,
		@DISCStyle = @DISCStyleCode,
		@SaleTypeCode = @SaleTypeCode,
		@SaleType = @SaleType,
		@CenterNumber = @CenterNumber,
		@UpdateUser = @UpdatedBy,
		@UpdateDate = @UpdateDate,
		@ActivitySource = @SourceCode,
		@ActivityPromo = @PromoCode,
		@TimeZoneCode = @TimeZoneCode,
		@SF_ID = @SF_ID


	-- Create Audit Record
	EXEC extSalesforceToHcmAuditRecordInsert
		@BatchID = @BatchID,
		@TableName = 'SFDC_HCM_LeadTask',
		@SF_ID = @SF_ID,
		@OnContactID = @ActivityID,
		@ActionTaken = 'Updated Record',
		@SortOrder = 3
END

END
GO
