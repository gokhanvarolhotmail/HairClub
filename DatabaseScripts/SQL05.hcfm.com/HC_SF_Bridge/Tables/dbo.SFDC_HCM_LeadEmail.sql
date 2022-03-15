/* CreateDate: 03/15/2022 10:27:32.190 , ModifyDate: 03/15/2022 11:26:09.337 */
GO
CREATE TABLE [dbo].[SFDC_HCM_LeadEmail](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncContactEmailID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncContactID__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Primary__c] [bit] NULL,
	[Status__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[BatchID] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Converted__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_OncContactEmailID__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_OncContactID__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Primary__c] [bit] NULL,
	[Dest_Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_CreatedDate] [datetime] NULL,
	[Dest_LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_LastModifiedDate] [datetime] NULL,
	[Dest_BatchID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Converted__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NULL,
	[IsExcludedFlag] [bit] NULL,
	[cst_sfdc_lead_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
