/* CreateDate: 03/22/2022 08:26:04.030 , ModifyDate: 03/22/2022 08:26:04.030 */
GO
CREATE TABLE [dbo].[SaleTypeCode__c](
	[Id] [int] NOT NULL,
	[SaleTypeCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SaleTypeDescription__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
