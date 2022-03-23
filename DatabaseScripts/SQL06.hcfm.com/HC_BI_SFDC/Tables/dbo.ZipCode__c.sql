/* CreateDate: 03/22/2022 09:49:14.680 , ModifyDate: 03/22/2022 09:49:14.680 */
GO
CREATE TABLE [dbo].[ZipCode__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State__c] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[County__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country__c] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMA__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timezone__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
