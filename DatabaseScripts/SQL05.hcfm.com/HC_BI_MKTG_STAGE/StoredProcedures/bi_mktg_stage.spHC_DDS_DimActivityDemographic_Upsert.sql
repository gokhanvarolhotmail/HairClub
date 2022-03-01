/* CreateDate: 08/05/2019 11:13:55.143 , ModifyDate: 02/24/2022 10:01:54.387 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_DimActivityDemographic_Upsert]
    @DataPkgKey           INT
  , @IgnoreRowCnt         BIGINT OUTPUT
  , @InsertRowCnt         BIGINT OUTPUT
  , @UpdateRowCnt         BIGINT OUTPUT
  , @ExceptionRowCnt      BIGINT OUTPUT
  , @ExtractRowCnt        BIGINT OUTPUT
  , @InsertNewRowCnt      BIGINT OUTPUT
  , @InsertInferredRowCnt BIGINT OUTPUT
  , @InsertSCD2RowCnt     BIGINT OUTPUT
  , @UpdateInferredRowCnt BIGINT OUTPUT
  , @UpdateSCD1RowCnt     BIGINT OUTPUT
  , @UpdateSCD2RowCnt     BIGINT OUTPUT
  , @InitialRowCnt        BIGINT OUTPUT
  , @FinalRowCnt          BIGINT OUTPUT
AS
-------------------------------------------------------------------------
-- [spHC_DDS_DimActivityDemographic_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_mktg_stage].[spHC_DDS_DimActivityDemographic_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/16/2009  RLifke       Initial Creation
--			03/29/2013  KMurdoch	 Added DiscStyleSSID
--			03/29/2013  KMurdoch     Added update of DiscStyleSSID
--			01/31/2017  DLeiba		 Updated query to handle a
--									 NULL value for Birthday & Age
--			11/21/2017  KMurdoch     Added SFDC_Lead/Task_ID
--			08/05/2019  KMurdoch	 Migrated ONC to SFDC
--			08/06/2019  KMurdoch     Made SFDC primary
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
-------------------------------------------------------------------------

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON ;

DECLARE
    @intError        INT -- error code
  , @intDBErrorLogID INT -- ID of error record logged
  , @intRowCount     INT -- count of rows modified
  , @vchTagValueList NVARCHAR(1000) -- Named Valued Pairs of Parameters
  , @return_value    INT
  , @TableName       VARCHAR(150)  = N'[bi_mktg_dds].[DimActivityDemographic]' -- Name of table
  , @DeletedRowCnt   BIGINT
  , @DuplicateRowCnt BIGINT
  , @HealthyRowCnt   BIGINT
  , @RejectedRowCnt  BIGINT
  , @AllowedRowCnt   BIGINT
  , @FixedRowCnt     BIGINT
  , @OrphanedRowCnt  BIGINT ;

    BEGIN TRY
        SELECT
            @IgnoreRowCnt = 0
          , @InsertRowCnt = 0
          , @UpdateRowCnt = 0
          , @ExceptionRowCnt = 0
          , @ExtractRowCnt = 0
          , @InsertNewRowCnt = 0
          , @InsertInferredRowCnt = 0
          , @InsertSCD2RowCnt = 0
          , @UpdateInferredRowCnt = 0
          , @UpdateSCD1RowCnt = 0
          , @UpdateSCD2RowCnt = 0
          , @InitialRowCnt = 0
          , @FinalRowCnt = 0
          , @DeletedRowCnt = 0
          , @DuplicateRowCnt = 0
          , @HealthyRowCnt = 0
          , @RejectedRowCnt = 0
          , @AllowedRowCnt = 0
          , @FixedRowCnt = 0
          , @OrphanedRowCnt = 0 ;

        -- Data pkg auditing
        EXEC @return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName ;

        -- Determine Initial Row Cnt
        SELECT @InitialRowCnt = COUNT(1)
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]
        OPTION( RECOMPILE ) ;

        -- Determine the number of extracted rows
        SELECT @ExtractRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        ------------------------
        -- Deleted Records
        ------------------------
        DELETE [k]
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [k]
        WHERE [ActivityDemographicSSID] IN( SELECT [STG].[ActivityDemographicSSID] FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG] WHERE [STG].[IsDelete] = 1
                                                                                                                                          AND [STG].[DataPkgKey] = @DataPkgKey )
        OPTION( RECOMPILE ) ;

        --------------------------
        ---- Deleted Records
        --------------------------
        --DELETE
        --FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]
        --WHERE [ActivityDemographicSSID] NOT
        --IN (
        --		SELECT SRC.[activity_demographic_id]
        --		FROM [HCM].[dbo].[cstd_activity_demographic] SRC WITH (NOLOCK)
        --		)
        --AND [ActivityDemographicKey] <> -1

        --SET @OrphanedRowCnt = @@ROWCOUNT

        ------------------------
        -- New Records
        ------------------------
        INSERT INTO [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]( [ActivityDemographicSSID]
                                                                           , [ActivitySSID]
                                                                           , [ContactSSID]
                                                                           , [GenderSSID]
                                                                           , [GenderDescription]
                                                                           , [EthnicitySSID]
                                                                           , [EthnicityDescription]
                                                                           , [OccupationSSID]
                                                                           , [OccupationDescription]
                                                                           , [MaritalStatusSSID]
                                                                           , [MaritalStatusDescription]
                                                                           , [Birthday]
                                                                           , [Age]
                                                                           , [AgeRangeSSID]
                                                                           , [AgeRangeDescription]
                                                                           , [HairLossTypeSSID]
                                                                           , [HairLossTypeDescription]
                                                                           , [NorwoodSSID]
                                                                           , [LudwigSSID]
                                                                           , [Performer]
                                                                           , [PriceQuoted]
                                                                           , [SolutionOffered]
                                                                           , [NoSaleReason]
                                                                           , [DiscStyleSSID]
                                                                           , [SFDC_LeadID]
                                                                           , [SFDC_TaskID]
                                                                           , [SFDC_PersonAccountID]
                                                                           , [DateSaved]
                                                                           , [RowIsCurrent]
                                                                           , [RowStartDate]
                                                                           , [RowEndDate]
                                                                           , [RowChangeReason]
                                                                           , [RowIsInferred]
                                                                           , [InsertAuditKey]
                                                                           , [UpdateAuditKey] )
        SELECT
            [STG].[ActivityDemographicSSID]
          , [STG].[ActivitySSID]
          , [STG].[ContactSSID]
          , [STG].[GenderSSID]
          , [STG].[GenderDescription]
          , [STG].[EthnicitySSID]
          , [STG].[EthnicityDescription]
          , [STG].[OccupationSSID]
          , [STG].[OccupationDescription]
          , [STG].[MaritalStatusSSID]
          , [STG].[MaritalStatusDescription]
          , ISNULL([STG].[Birthday], '1900-01-01')
          , ISNULL([STG].[Age], 0)
          , [STG].[AgeRangeSSID]
          , [STG].[AgeRangeDescription]
          , [STG].[HairLossTypeSSID]
          , [STG].[HairLossTypeDescription]
          , [STG].[NorwoodSSID]
          , [STG].[LudwigSSID]
          , [STG].[Performer]
          , [STG].[PriceQuoted]
          , [STG].[SolutionOffered]
          , [STG].[NoSaleReason]
          , [STG].[DiscStyleSSID]
          , [STG].[SFDC_LeadID]
          , [STG].[SFDC_TaskID]
          , [STG].[SFDC_PersonAccountID]
          , [STG].[DateSaved]
          , 1 -- [RowIsCurrent]
          , CAST('1753-01-01 00:00:00' AS DATETIME) -- [RowStartDate]
          , CAST('9999-12-31 00:00:00' AS DATETIME) -- [RowEndDate]
          , 'New Record' -- [RowChangeReason]
          , 0
          , @DataPkgKey
          , -2 -- 'Not Updated Yet'
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[IsNew] = 1 AND [STG].[IsException] = 0 AND [STG].[IsDuplicate] = 0 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        SET @InsertNewRowCnt = @@ROWCOUNT ;

        ------------------------
        -- Inferred Members
        ------------------------
        -- Just update the record
        UPDATE
            [DW]
        SET
            [DW].[ActivitySSID] = [STG].[ActivitySSID]
          , [DW].[ContactSSID] = [STG].[ContactSSID]
          , [DW].[GenderSSID] = [STG].[GenderSSID]
          , [DW].[GenderDescription] = [STG].[GenderDescription]
          , [DW].[EthnicitySSID] = [STG].[EthnicitySSID]
          , [DW].[EthnicityDescription] = [STG].[EthnicityDescription]
          , [DW].[OccupationSSID] = [STG].[OccupationSSID]
          , [DW].[OccupationDescription] = [STG].[OccupationDescription]
          , [DW].[MaritalStatusSSID] = [STG].[MaritalStatusSSID]
          , [DW].[MaritalStatusDescription] = [STG].[MaritalStatusDescription]
          , [DW].[Birthday] = ISNULL([STG].[Birthday], '1900-01-01')
          , [DW].[Age] = ISNULL([STG].[Age], 0)
          , [DW].[AgeRangeSSID] = [STG].[AgeRangeSSID]
          , [DW].[AgeRangeDescription] = [STG].[AgeRangeDescription]
          , [DW].[HairLossTypeSSID] = [STG].[HairLossTypeSSID]
          , [DW].[HairLossTypeDescription] = [STG].[HairLossTypeDescription]
          , [DW].[NorwoodSSID] = [STG].[NorwoodSSID]
          , [DW].[LudwigSSID] = [STG].[LudwigSSID]
          , [DW].[Performer] = [STG].[Performer]
          , [DW].[PriceQuoted] = [STG].[PriceQuoted]
          , [DW].[SolutionOffered] = [STG].[SolutionOffered]
          , [DW].[NoSaleReason] = [STG].[NoSaleReason]
          , [DW].[DiscStyleSSID] = [STG].[DiscStyleSSID]
          , [DW].[SFDC_LeadID] = [STG].[SFDC_LeadID]
          , [DW].[SFDC_TaskID] = [STG].[SFDC_TaskID]
          , [DW].[SFDC_PersonAccountID] = [STG].[SFDC_PersonAccountID]
          , [DW].[DateSaved] = [STG].[DateSaved]
          , [DW].[RowChangeReason] = 'Updated Inferred Member'
          , [DW].[RowIsInferred] = 0
          , [DW].[UpdateAuditKey] = @DataPkgKey
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DW] ON [DW].[SFDC_TaskID] = [STG].[SFDC_TaskID]
                                                                            AND [DW].[RowIsCurrent] = 1
                                                                            AND [DW].[RowIsInferred] = 1
        WHERE [STG].[IsInferredMember] = 1 AND [STG].[IsException] = 0 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        SET @UpdateInferredRowCnt = @@ROWCOUNT ;

        ------------------------
        -- SCD Type 1
        ------------------------
        -- Just update the record
        UPDATE [DW]
        SET
            [DW].[ActivitySSID] = [STG].[ActivitySSID]
          , [DW].[ContactSSID] = [STG].[ContactSSID]
          , [DW].[GenderSSID] = [STG].[GenderSSID]
          , [DW].[GenderDescription] = [STG].[GenderDescription]
          , [DW].[EthnicitySSID] = [STG].[EthnicitySSID]
          , [DW].[EthnicityDescription] = [STG].[EthnicityDescription]
          , [DW].[OccupationSSID] = [STG].[OccupationSSID]
          , [DW].[OccupationDescription] = [STG].[OccupationDescription]
          , [DW].[MaritalStatusSSID] = [STG].[MaritalStatusSSID]
          , [DW].[MaritalStatusDescription] = [STG].[MaritalStatusDescription]
          , [DW].[Birthday] = ISNULL([STG].[Birthday], '1900-01-01')
          , [DW].[Age] = ISNULL([STG].[Age], 0)
          , [DW].[AgeRangeSSID] = [STG].[AgeRangeSSID]
          , [DW].[AgeRangeDescription] = [STG].[AgeRangeDescription]
          , [DW].[HairLossTypeSSID] = [STG].[HairLossTypeSSID]
          , [DW].[HairLossTypeDescription] = [STG].[HairLossTypeDescription]
          , [DW].[NorwoodSSID] = [STG].[NorwoodSSID]
          , [DW].[LudwigSSID] = [STG].[LudwigSSID]
          , [DW].[Performer] = [STG].[Performer]
          , [DW].[PriceQuoted] = [STG].[PriceQuoted]
          , [DW].[SolutionOffered] = [STG].[SolutionOffered]
          , [DW].[NoSaleReason] = [STG].[NoSaleReason]
          , [DW].[DiscStyleSSID] = [STG].[DiscStyleSSID]
          , [DW].[SFDC_LeadID] = [STG].[SFDC_LeadID]
          , [DW].[SFDC_TaskID] = [STG].[SFDC_TaskID]
          , [DW].[SFDC_PersonAccountID] = [STG].[SFDC_PersonAccountID]
          , [DW].[DateSaved] = [STG].[DateSaved]
          , [DW].[RowChangeReason] = 'SCD Type 1'
          , [DW].[UpdateAuditKey] = @DataPkgKey
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DW] ON [DW].[SFDC_TaskID] = [STG].[SFDC_TaskID] AND [DW].[RowIsCurrent] = 1
        WHERE [STG].[IsType1] = 1 AND [STG].[IsException] = 0 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        SET @UpdateSCD1RowCnt = @@ROWCOUNT ;

        ------------------------
        -- SCD Type 2
        ------------------------
        -- First Expire the current row
        UPDATE
            [DW]
        SET
            [DW].[RowIsCurrent] = 0
          , [DW].[RowEndDate] = DATEADD(MINUTE, -1, [STG].[ModifiedDate])
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DW] ON [DW].[ActivityDemographicKey] = [STG].[ActivityDemographicKey]
                                                                            AND [DW].[RowIsCurrent] = 1
        WHERE [STG].[IsType2] = 1 AND [STG].[IsException] = 0 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        SET @UpdateSCD2RowCnt = @@ROWCOUNT ;

        --Next insert the record with the current values
        INSERT INTO [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]( [ActivityDemographicSSID]
                                                                           , [ActivitySSID]
                                                                           , [ContactSSID]
                                                                           , [GenderSSID]
                                                                           , [GenderDescription]
                                                                           , [EthnicitySSID]
                                                                           , [EthnicityDescription]
                                                                           , [OccupationSSID]
                                                                           , [OccupationDescription]
                                                                           , [MaritalStatusSSID]
                                                                           , [MaritalStatusDescription]
                                                                           , [Birthday]
                                                                           , [Age]
                                                                           , [AgeRangeSSID]
                                                                           , [AgeRangeDescription]
                                                                           , [HairLossTypeSSID]
                                                                           , [HairLossTypeDescription]
                                                                           , [NorwoodSSID]
                                                                           , [LudwigSSID]
                                                                           , [Performer]
                                                                           , [PriceQuoted]
                                                                           , [SolutionOffered]
                                                                           , [NoSaleReason]
                                                                           , [DiscStyleSSID]
                                                                           , [SFDC_LeadID]
                                                                           , [SFDC_TaskID]
                                                                           , [SFDC_PersonAccountID]
                                                                           , [DateSaved]
                                                                           , [RowIsCurrent]
                                                                           , [RowStartDate]
                                                                           , [RowEndDate]
                                                                           , [RowChangeReason]
                                                                           , [RowIsInferred]
                                                                           , [InsertAuditKey]
                                                                           , [UpdateAuditKey] )
        SELECT
            [STG].[ActivityDemographicSSID]
          , [STG].[ActivitySSID]
          , [STG].[ContactSSID]
          , [STG].[GenderSSID]
          , [STG].[GenderDescription]
          , [STG].[EthnicitySSID]
          , [STG].[EthnicityDescription]
          , [STG].[OccupationSSID]
          , [STG].[OccupationDescription]
          , [STG].[MaritalStatusSSID]
          , [STG].[MaritalStatusDescription]
          , ISNULL([STG].[Birthday], '1900-01-01')
          , ISNULL([STG].[Age], 0)
          , [STG].[AgeRangeSSID]
          , [STG].[AgeRangeDescription]
          , [STG].[HairLossTypeSSID]
          , [STG].[HairLossTypeDescription]
          , [STG].[NorwoodSSID]
          , [STG].[LudwigSSID]
          , [STG].[Performer]
          , [STG].[PriceQuoted]
          , [STG].[SolutionOffered]
          , [STG].[NoSaleReason]
          , [STG].[DiscStyleSSID]
          , [STG].[SFDC_LeadID]
          , [STG].[SFDC_TaskID]
          , [STG].[SFDC_PersonAccountID]
          , [STG].[DateSaved]
          , 1 -- [RowIsCurrent]
          , [STG].[ModifiedDate] -- [RowStartDate]
          , CAST('9999-12-31 00:00:00' AS DATETIME) -- [RowEndDate]
          , 'SCD Type 2' -- [RowChangeReason]
          , 0
          , @DataPkgKey
          , -2 -- 'Not Updated Yet'
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[IsType2] = 1 AND [STG].[IsException] = 0 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        SET @InsertSCD2RowCnt = @@ROWCOUNT ;

        --Update DimContact DiscStyleSSID
        UPDATE [DimContact]
        SET [DiscStyleSSID] = ISNULL([DimActivityDemographic].[DiscStyleSSID], 'u')
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] AS [DimContact]
        INNER JOIN [bi_mktg_stage].[DimActivityDemographic] AS [DimActivityDemographic] ON [DimContact].[SFDC_LeadID] = [DimActivityDemographic].[SFDC_LeadID]
        OPTION( RECOMPILE ) ;

        --ON ISNULL(DimContact.SFDC_LeadID, DimContact.ContactSSID) = ISNULL(DimActivityDemographic.SFDC_LeadID, DimActivityDemographic.ContactSSID)

        -- Determine the number of exception rows
        SELECT @ExceptionRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[IsException] = 1 AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        -- Determine the number of inserted and updated rows
        SELECT
            @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
          , @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt ;

        -- Determine the number of ignored rows
        SELECT @IgnoreRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[IsException] = 0
          AND [STG].[IsNew] = 0
          AND [STG].[IsType1] = 0
          AND [STG].[IsType2] = 0
           OR [STG].[IsDuplicate] = 1
          AND [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        -- Determine Final Row Cnt
        SELECT @FinalRowCnt = COUNT(1)
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]
        OPTION( RECOMPILE ) ;

        -- Determine the number of Fixed rows
        SELECT @FixedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsFixed] = 1
        OPTION( RECOMPILE ) ;

        -- Determine the number of Allowed rows
        SELECT @AllowedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsAllowed] = 1
        OPTION( RECOMPILE ) ;

        -- Determine the number of Rejected rows
        SELECT @RejectedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsRejected] = 1
        OPTION( RECOMPILE ) ;

        -- Determine the number of Healthy rows
        SELECT @HealthyRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsRejected] = 0 AND [STG].[IsAllowed] = 0 AND [STG].[IsFixed] = 0
        OPTION( RECOMPILE ) ;

        -- Determine the number of Duplicate rows
        SELECT @DuplicateRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsDuplicate] = 1
        OPTION( RECOMPILE ) ;

        -- Determine the number of Deleted rows
        SELECT @DeletedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey AND [STG].[IsDelete] = 1
        OPTION( RECOMPILE ) ;

        -- Included deleted orphaned rows
        SET @DeletedRowCnt = @DeletedRowCnt + @OrphanedRowCnt ;

        -----------------------
        -- Flag records as validated
        -----------------------
        UPDATE [STG]
        SET [STG].[IsLoaded] = 1
        FROM [bi_mktg_stage].[DimActivityDemographic] AS [STG]
        WHERE [STG].[DataPkgKey] = @DataPkgKey
        OPTION( RECOMPILE ) ;

        -- Data pkg auditing
        EXEC @return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop]
            @DataPkgKey
          , @TableName
          , @IgnoreRowCnt
          , @InsertRowCnt
          , @UpdateRowCnt
          , @ExceptionRowCnt
          , @ExtractRowCnt
          , @InsertNewRowCnt
          , @InsertInferredRowCnt
          , @InsertSCD2RowCnt
          , @UpdateInferredRowCnt
          , @UpdateSCD1RowCnt
          , @UpdateSCD2RowCnt
          , @InitialRowCnt
          , @FinalRowCnt
          , @DeletedRowCnt
          , @DuplicateRowCnt
          , @HealthyRowCnt
          , @RejectedRowCnt
          , @AllowedRowCnt
          , @FixedRowCnt ;

        -- Cleanup
        -- Reset SET NOCOUNT to OFF.
        SET NOCOUNT OFF ;

        -- Cleanup temp tables

        -- Return success
        RETURN 0 ;
    END TRY
    BEGIN CATCH
        -- Save original error number
        SET @intError = ERROR_NUMBER() ;

        -- Log the error
        EXECUTE [bief_stage].[_DBErrorLog_LogError] @DBErrorLogID = @intDBErrorLogID OUTPUT, @tagValueList = @vchTagValueList ;

        -- Re Raise the error
        EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList ;

        -- Cleanup
        -- Reset SET NOCOUNT to OFF.
        SET NOCOUNT OFF ;

        -- Cleanup temp tables

        -- Return the error number
        RETURN @intError ;
    END CATCH ;
GO
