-- SQL05
USE [HC_Marketing] ;
GO
/***********************************************************************
PROCEDURE:				spSvc_GetRefersionData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Refersion
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/03/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetRefersionData ''
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetRefersionData_GVAROL]
    @SessionID NVARCHAR(100)
AS
SET FMTONLY OFF ;

SET NOCOUNT OFF ;

DECLARE
    @CurrentDate    DATE          = GETDATE()
  , @TargetDate     AS DATE       = DATEADD(DAY, -1, GETDATE())
  , @RefersionLogID INT
  , @first_name     NVARCHAR(40)
  , @last_name      NVARCHAR(40)
  , @email          NVARCHAR(40)
  , @discount_code  NVARCHAR(20)
  , @sku            NVARCHAR(10)
  , @price          NVARCHAR(10)
  , @quantity       NVARCHAR(3)
  , @currency_code  NVARCHAR(10)
  , @ip_address     NVARCHAR(20)
  , @data           NVARCHAR(4000)
  , @batchID        INT           = 1
  , @rowCount       INT           = 1 ;

-- Get Leads Created within time period
INSERT INTO [dbo].[datRefersionLog]
SELECT
    [rp].[RefersionProcessID]
  , @SessionID AS [SessionID]
  , -1 AS [BatchID]
  , NULL AS [ClientIdentifier]
  , [l].[Id] AS [SFDC_LeadID]
  , [l].[FirstName]
  , [l].[LastName]
  , [l].[Email]
  , [l].[ReferralCode__c]
  , [l].[ReferralCodeExpireDate__c]
  , 'Step1' AS [Sku]
  , NULL AS [SalesOrderKey]
  , 0 AS [Price]
  , 1 AS [Quantity]
  , 'USD' AS [CurrencyCode]
  , '127.0.0.1' AS [IPAddress]
  , NULL AS [JsonData]
  , NULL AS [ResponseCode]
  , NULL AS [ResponseVerbiage]
  , [rs].[RefersionStatusID]
  , [o_Rl].[RefersionLogID] AS [OriginalRefersionLogID]
  , 0 AS [IsReprocessFlag]
  , GETDATE() AS [CreateDate]
  , 'Refersion-HCM' AS [CreateUser]
  , GETDATE() AS [LastUpdate]
  , 'Refersion-HCM' AS [LastUpdateUser]
FROM [SQL06].[HC_BI_SFDC].[dbo].[Lead] AS [l] WITH( NOLOCK )
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionProcess] AS [rp] ON [rp].[RefersionProcessDescriptionShort] = 'LEADCREATE' AND [rp].[IsActiveFlag] = 1
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionStatus] AS [rs] ON [rs].[RefersionStatusDescriptionShort] = 'PENDING'
OUTER APPLY( SELECT TOP 1
                    [rl].[RefersionLogID]
                  , [rl].[SFDC_LeadID]
                  , [rl].[IsReprocessFlag]
             FROM [HC_Marketing].[dbo].[datRefersionLog] AS [rl]
             WHERE [rl].[RefersionProcessID] = [rp].[RefersionProcessID] AND [rl].[SFDC_LeadID] = [l].[Id]
             ORDER BY [rl].[CreateDate] DESC ) AS [o_Rl]
WHERE( CAST(ISNULL([l].[ReportCreateDate__c], [l].[CreatedDate]) AS DATE) >= @TargetDate OR CAST([l].[LastModifiedDate] AS DATE) >= @TargetDate )
  AND [l].[Status] IN ('Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
                     , 'Pursuing my Story', 'Pursuing_my_Story', 'Scheduled', 'Establishing_Value', 'Establishing Value', 'Converted') --- add new lead Status
  AND ( ISNULL([l].[ReferralCode__c], '') <> '' AND ISNULL([l].[ReferralCode__c], '') <> 'null' AND [l].[ReferralCodeExpireDate__c] >= GETDATE()
    --    AND (l.Source_Code_Legacy__c IN
    --        ('IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
    --         'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP')
    --       OR l.RecentSourceCode__c IN
    --          ('IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
    --           'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'))
    )
  AND ISNULL([l].[IsDeleted], 0) = 0
  AND ( [o_Rl].[RefersionLogID] IS NULL OR [o_Rl].[IsReprocessFlag] = 1 ) ;

-- Get Shows that occurred within time period
INSERT INTO [dbo].[datRefersionLog]
SELECT
    [rp].[RefersionProcessID]
  , @SessionID AS [SessionID]
  , -1 AS [BatchID]
  , [clt].[ClientIdentifier] AS [ClientIdentifier]
  , [l].[Id] AS [SFDC_LeadID]
  , [l].[FirstName]
  , [l].[LastName]
  , ISNULL([l].[Email], [clt].[EMailAddress]) AS [EmailAddress]
  , [l].[ReferralCode__c]
  , [l].[ReferralCodeExpireDate__c]
  , 'Step2' AS [Sku]
  , NULL AS [SalesOrderKey]
  , 0 AS [Price]
  , 1 AS [Quantity]
  , 'USD' AS [CurrencyCode]
  , '127.0.0.1' AS [IPAddress]
  , NULL AS [JsonData]
  , NULL AS [ResponseCode]
  , NULL AS [ResponseVerbiage]
  , [rs].[RefersionStatusID]
  , [o_Rl].[RefersionLogID] AS [OriginalRefersionLogID]
  , 0 AS [IsReprocessFlag]
  , GETDATE() AS [CreateDate]
  , 'Refersion-HCM' AS [CreateUser]
  , GETDATE() AS [LastUpdate]
  , 'Refersion-HCM' AS [LastUpdateUser]
FROM [SQL06].[HC_BI_SFDC].[dbo].[Task] AS [t] WITH( NOLOCK )
INNER JOIN [SQL06].[HC_BI_SFDC].[dbo].[Lead] AS [l] WITH( NOLOCK )ON [l].[Id] = [t].[WhoId] OR [l].[externalid] = [t].[WhoId]
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionProcess] AS [rp] ON [rp].[RefersionProcessDescriptionShort] = 'LEADSHOW' AND [rp].[IsActiveFlag] = 1
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionStatus] AS [rs] ON [rs].[RefersionStatusDescriptionShort] = 'PENDING'
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [clt] ON [clt].[SalesforceContactID] = [l].[Id]
                                                    OR [clt].[SalesforceContactID] = [l].[ConvertedAccountId]
                                                    OR [clt].[SalesforceContactID] = [l].[externalid]
OUTER APPLY( SELECT TOP 1
                    [rl].[RefersionLogID]
                  , [rl].[SFDC_LeadID]
                  , [rl].[IsReprocessFlag]
             FROM [HC_Marketing].[dbo].[datRefersionLog] AS [rl]
             WHERE [rl].[RefersionProcessID] = [rp].[RefersionProcessID] AND [rl].[SFDC_LeadID] = [l].[Id]
             ORDER BY [rl].[CreateDate] DESC ) AS [o_Rl]
WHERE( [t].[ActivityDate] >= @TargetDate OR [t].[CompletionDate__c] >= @TargetDate OR [t].[LastModifiedDate] >= @TargetDate )
  AND [t].[Action__c] IN ('Appointment', 'In House', 'Be Back')
  AND ISNULL([t].[Result__c], '') IN ('Show Sale', 'Show No Sale')
  AND ISNULL([l].[Email], [clt].[EMailAddress]) <> ''
  AND ( ISNULL([t].[ReferralCode__c], '') <> '' AND ISNULL([l].[ReferralCode__c], '') <> 'null' AND [l].[ReferralCodeExpireDate__c] >= GETDATE()
    --    AND t.SourceCode__c IN
    --       ('IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
    --        'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP')
    )
  AND ISNULL([t].[IsDeleted], 0) = 0
  AND [l].[Status] IN ('Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
                     , 'Pursuing my Story', 'Pursuing_my_Story', 'Scheduled', 'Establishing_Value', 'Establishing Value', 'Converted')
  AND ISNULL([l].[IsDeleted], 0) = 0
  AND ( [o_Rl].[RefersionLogID] IS NULL OR [o_Rl].[IsReprocessFlag] = 1 ) ;

-- Get Clients that been serviced and a commission record has been created within time period
INSERT INTO [dbo].[datRefersionLog]
SELECT
    [rp].[RefersionProcessID]
  , @SessionID AS [SessionID]
  , -1 AS [BatchID]
  , [clt].[ClientIdentifier]
  , [l].[Id] AS [SFDC_LeadID]
  , [l].[FirstName]
  , [l].[LastName]
  , ISNULL([l].[Email], [clt].[ClientEMailAddress]) AS [EmailAddress]
  , [l].[ReferralCode__c]
  , [l].[ReferralCodeExpireDate__c]
  , 'Step3' AS [Sku]
  , [fch].[SalesOrderKey]
  , [dbo].[DIVIDE_DECIMAL]([fch].[AdvancedCommission], [fch].[PlanPercentage]) AS [Price]
  , 1 AS [Quantity]
  , 'USD' AS [CurrencyCode]
  , '127.0.0.1' AS [IPAddress]
  , NULL AS [JsonData]
  , NULL AS [ResponseCode]
  , NULL AS [ResponseVerbiage]
  , [rs].[RefersionStatusID]
  , [o_Rl].[RefersionLogID] AS [OriginalRefersionLogID]
  , 0 AS [IsReprocessFlag]
  , GETDATE() AS [CreateDate]
  , 'Refersion-HCM' AS [CreateUser]
  , GETDATE() AS [LastUpdate]
  , 'Refersion-HCM' AS [LastUpdateUser]
FROM [SQL06].[HC_Commission].[dbo].[FactCommissionHeader] AS [fch]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClient] AS [clt] ON [clt].[ClientKey] = [fch].[ClientKey]
INNER JOIN [SQL06].[HC_BI_SFDC].[dbo].[Lead] AS [l] ON [l].[Id] = [clt].[SFDC_Leadid]
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionProcess] AS [rp] ON [rp].[RefersionProcessDescriptionShort] = 'CLIENTSVC' AND [rp].[IsActiveFlag] = 1
INNER JOIN [HC_Marketing].[dbo].[lkpRefersionStatus] AS [rs] ON [rs].[RefersionStatusDescriptionShort] = 'PENDING'
OUTER APPLY( SELECT TOP 1
                    [rl].[RefersionLogID]
                  , [rl].[SFDC_LeadID]
                  , [rl].[IsReprocessFlag]
             FROM [HC_Marketing].[dbo].[datRefersionLog] AS [rl]
             WHERE [rl].[RefersionProcessID] = [rp].[RefersionProcessID] AND [rl].[SalesOrderKey] = [fch].[SalesOrderKey]
             ORDER BY [rl].[CreateDate] DESC ) AS [o_Rl]
WHERE [fch].[CommissionTypeID] IN (29, 30, 3, 46, 47, 77, 53, 54, 4)
  AND ISNULL([fch].[AdvancedCommission], 0) > 0
  AND ISNULL([l].[Email], [clt].[ClientEMailAddress]) <> ''
  AND [l].[Status] IN ('Lead', 'Client', 'Prospect', 'Event', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
                     , 'Pursuing my Story', 'Pursuing_my_Story', 'Scheduled', 'Establishing_Value', 'Establishing Value', 'Converted')
  AND ( ISNULL([l].[ReferralCode__c], '') <> '' AND ISNULL([l].[ReferralCode__c], '') <> 'null' AND [l].[ReferralCodeExpireDate__c] >= GETDATE()
    --  AND (l.Source_Code_Legacy__c IN
    --       ('IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
    --        'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP')
    --    OR l.RecentSourceCode__c IN
    --       ('IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
    --         'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'))
    )
  AND ISNULL([l].[IsDeleted], 0) = 0
  AND ( [o_Rl].[RefersionLogID] IS NULL OR [o_Rl].[IsReprocessFlag] = 1 ) ;

-- Update Json
DECLARE [db_refersion_cursor] CURSOR FOR
SELECT
    [rl].[RefersionLogID]
  , [rl].[FirstName]
  , [rl].[LastName]
  , [rl].[EmailAddress]
  , [rl].[ReferralCode__c]
  , [rl].[Sku]
  , [rl].[Price]
  , [rl].[Quantity]
  , [rl].[CurrencyCode]
  , [rl].[IPAddress]
FROM [HC_Marketing].[dbo].[datRefersionLog] AS [rl]
WHERE [rl].[SessionGUID] = @SessionID AND ISNULL([rl].[JsonData], '') = '' ;

OPEN [db_refersion_cursor] ;

FETCH NEXT FROM [db_refersion_cursor]
INTO
    @RefersionLogID
  , @first_name
  , @last_name
  , @email
  , @discount_code
  , @sku
  , @price
  , @quantity
  , @currency_code
  , @ip_address ;

WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @data = N'{
    "items": [
            {
            "price":' + @price + N',
            "quantity":' + @quantity + N',
            "sku": "' + @sku + N'"
            }
    ],
    "order_id": "' + CONVERT(VARCHAR, @RefersionLogID) + N'",
    "discount_code": "' + @discount_code + N'",
    "currency_code": "' + @currency_code + N'",
    "customer": {
            "email": "' + @email + N'",
            "ip_address": "' + @ip_address + N'",
            "last_name": "' + @last_name + N'",
            "first_name": "' + @first_name + N'"
    },
    "cart_id": "' + CONVERT(VARCHAR, @RefersionLogID) + N'"
    }'  ;

        UPDATE [dbo].[datRefersionLog]
        SET [JsonData] = @data
        WHERE [RefersionLogID] = @RefersionLogID ;

        FETCH NEXT FROM [db_refersion_cursor]
        INTO
            @RefersionLogID
          , @first_name
          , @last_name
          , @email
          , @discount_code
          , @sku
          , @price
          , @quantity
          , @currency_code
          , @ip_address ;
    END ;

CLOSE [db_refersion_cursor] ;
DEALLOCATE [db_refersion_cursor] ;

-- Update Batch ID
WHILE @rowCount > 0
    BEGIN
        WITH [NextBatch]
        AS ( SELECT TOP 100 * FROM [dbo].[datRefersionLog] AS [rl] WHERE [rl].[SessionGUID] = @SessionID AND [rl].[BatchID] = -1 )
        UPDATE [dbo].[datRefersionLog]
        SET [BatchID] = @batchID
        FROM [NextBatch]
        JOIN [dbo].[datRefersionLog] ON [NextBatch].[RefersionLogID] = [datRefersionLog].[RefersionLogID] ;

        SET @rowCount = @@ROWCOUNT ;
        SET @batchID = @batchID + 1 ;
    END ;

-- Return All Pending records for specific Session ID
SELECT
    [rl].[JsonData]
  , [rl].[RefersionLogID]
  , [rl].[ResponseCode]
FROM [dbo].[datRefersionLog] AS [rl]
INNER JOIN [dbo].[lkpRefersionStatus] AS [rs] ON [rs].[RefersionStatusID] = [rl].[RefersionStatusID]
WHERE [rl].[SessionGUID] = @SessionID AND [rs].[RefersionStatusDescriptionShort] = 'PENDING'
ORDER BY [rl].[RefersionLogID] ;

-- Reset records marked for reprocessing
UPDATE [rl]
SET [rl].[IsReprocessFlag] = 0
FROM [dbo].[datRefersionLog] AS [rl]
INNER JOIN [dbo].[datRefersionLog] AS [rl2] ON [rl2].[OriginalRefersionLogID] = [rl].[RefersionLogID]
WHERE [rl2].[OriginalRefersionLogID] IS NOT NULL AND [rl].[IsReprocessFlag] = 1 ;
GO