/* CreateDate: 12/27/2019 12:17:30.670 , ModifyDate: 03/10/2022 14:13:01.717 */
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
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ZipCode__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ZipCode__c] ADD  CONSTRAINT [DF_ZipCode__c_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
