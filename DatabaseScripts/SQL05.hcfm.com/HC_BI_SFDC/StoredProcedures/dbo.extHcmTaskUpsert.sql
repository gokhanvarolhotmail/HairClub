/* CreateDate: 06/11/2018 11:20:24.130 , ModifyDate: 06/11/2018 11:21:13.187 */
GO
/***********************************************************************
PROCEDURE:				extHcmTaskUpsert
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/11/2018
DESCRIPTION:			06/11/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHcmTaskUpsert ''
***********************************************************************/
CREATE PROCEDURE [dbo].[extHcmTaskUpsert]
(
	@SF_ID NVARCHAR(18)
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


SELECT  @ActivityID = t.ActivityID__c
,		@WhoId = t.WhoId
,		@ContactID = t.LeadOncContactID__c
,		@CenterNumber = ISNULL(t.CenterNumber__c, t.CenterID__c)
,		@ActionCode = shac.OnContact_ActionCode
,		@ResultCode = shrc.OnContact_ResultCode
,		@ActivityTypeCode = t.ActivityType__c
,		@Description = t.Action__c
,		@DueDate = CONVERT(VARCHAR(11), CAST(t.ActivityDate AS DATE), 101)
,		@StartTime = CONVERT(VARCHAR(15), CAST(t.StartTime__c AS TIME), 100)
,		@CompletionDate = CASE WHEN t.Result__c IS NULL THEN NULL ELSE CONVERT(VARCHAR(11), CAST(t.CompletionDate__c AS DATE), 101) END
,		@CompletionTime = CASE WHEN t.Result__c IS NULL THEN NULL ELSE CONVERT(VARCHAR(15), CAST(t.CompletionDate__c AS TIME), 100) END
,		@CompletedBy = CASE WHEN t.Result__c IS NULL THEN NULL ELSE ISNULL(shu_cbu.user_code, 'TM6100') END
,		@GenderCode = t.LeadOncGender__c
,		@Birthday = ISNULL(CONVERT(VARCHAR(11), CAST(t.LeadOncBirthday__c AS DATE), 101), '')
,		@OccupationCode = ISNULL(lo.BOSOccupationCode, '0')
,		@EthnicityCode = ISNULL(le.BOSEthnicityCode, '0')
,		@MaritalStatusCode = ISNULL(ms.BOSMaritalStatusCode, '0')
,		@NorwoodCode = ISNULL(ns.NorwoodScaleDescription, 'Unknown')
,		@LudwigCode = ISNULL(ls.LudwigScaleDescription, 'Unknown')
,		@Age = shlt.Age
,		@Performer = t.Performer__c
,		@PriceQuoted = ISNULL(t.PriceQuoted__c, 0.00)
,		@SolutionOffered = t.SolutionOffered__c
,		@NoSaleReason = t.NoSaleReason__c
,		@DISCStyleCode = ISNULL(ds.DISCStyleDescriptionShort, 'x')
,		@SaleTypeCode = t.SaleTypeCode__c
,		@SaleType = t.SaleTypeDescription__c
,		@SourceCode = t.SourceCode__c
,		@PromoCode = t.PromoCode__c
,		@TimeZoneCode = t.TimeZone__c
,       @CreatedBy = ISNULL(shu_cb.user_code, 'TM6100')
,       @CreateDate = t.CreatedDate
,       @UpdatedBy = ISNULL(shu_ub.user_code, ISNULL(shu_cb.user_code, 'TM6100'))
,       @UpdateDate = t.LastModifiedDate
FROM    Task t
        INNER JOIN SFDC_HCM_User shu_cb
            ON shu_cb.cst_sfdc_user_id = t.CreatedById
        INNER JOIN SFDC_HCM_User shu_ub
            ON shu_ub.cst_sfdc_user_id = t.LastModifiedId
        LEFT OUTER JOIN SFDC_HCM_User shu_cbu
            ON shu_cbu.cst_sfdc_user_id = t.OwnerId
        LEFT OUTER JOIN SFDC_HCM_ActionCode shac
            ON shac.SF_ActionCode = t.Action__c
				AND shac.IsActiveFlag = 1
        LEFT OUTER JOIN SFDC_HCM_ResultCode shrc
            ON shrc.SF_ResultCode = t.Result__c
				AND shrc.IsActiveFlag = 1
        LEFT OUTER JOIN HairClubCMS_lkpNorwoodScale_TABLE ns
            ON ns.NorwoodScaleDescription = t.NorwoodScale__c
        LEFT OUTER JOIN HairClubCMS_lkpLudwigScale_TABLE ls
            ON ls.LudwigScaleDescription = t.LudwigScale__c
        LEFT OUTER JOIN HairClubCMS_lkpMaritalStatus_TABLE ms
            ON ms.MaritalStatusDescription = t.MaritalStatus__c
        LEFT OUTER JOIN HairClubCMS_lkpOccupation_TABLE lo
            ON lo.OccupationDescription = t.Occupation__c
        LEFT OUTER JOIN HairClubCMS_lkpEthnicity_TABLE le
            ON le.EthnicityDescription = t.LeadOncEthnicity__c
        LEFT OUTER JOIN HairClubCMS_lkpDISCStyle_TABLE ds
            ON ds.DISCStyleDescription = t.DISC__c
WHERE   t.Id = @SF_ID


-- Check for Task in OnC Table.
IF ISNULL(@ActivityID, '') = ''
BEGIN
	SELECT  @OncActivityID = oa.activity_id
	FROM    OnContact_oncd_activity_TABLE oa
	WHERE   oa.cst_sfdc_task_id = @SF_ID


	IF ISNULL(@OncActivityID, '') <> ''
	BEGIN
		SET @ActivityID = @OncActivityID
	END
END


IF ISNULL(@ContactID, '') = ''
BEGIN
	SELECT  @OncContactID = l.ContactID__c
	FROM    Lead l
	WHERE   l.Id = @WhoId


	IF ISNULL(@OncContactID, '') <> ''
	BEGIN
		SET @ContactID = @OncContactID
	END
END


IF ISNULL(@CenterNumber, '') = ''
BEGIN
	SELECT  @OncCenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
	FROM    Lead l
	WHERE   l.Id = @WhoId


	IF ISNULL(@OncCenterNumber, '') <> ''
	BEGIN
		SET @CenterNumber = @OncCenterNumber
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
END

END
GO
