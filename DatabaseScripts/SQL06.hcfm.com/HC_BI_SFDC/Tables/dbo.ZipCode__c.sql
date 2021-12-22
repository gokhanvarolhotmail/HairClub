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
 CONSTRAINT [PK_ZipCode__c_1] PRIMARY KEY NONCLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [PK_ZipCode__c] ON [dbo].[ZipCode__c]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
