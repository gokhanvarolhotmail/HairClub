/* CreateDate: 04/17/2020 10:53:52.940 , ModifyDate: 03/21/2022 16:35:30.563 */
GO
CREATE TABLE [dbo].[PhoneScrub__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Batch__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExportDatetime__c] [datetime] NOT NULL,
	[ImportDatetime__c] [datetime] NULL,
	[ProcessDate__c] [datetime] NULL,
	[DoNotCall__c] [bit] NULL,
	[Wireless__c] [bit] NULL,
	[EBRDate__c] [datetime] NULL,
	[DoNotCodes__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WirelessCodes__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PhoneScrub__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PhoneScrub__c] ADD  CONSTRAINT [DF_PhoneScrub__c_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
