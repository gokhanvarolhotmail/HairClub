/* CreateDate: 10/22/2020 10:43:12.870 , ModifyDate: 10/22/2020 10:43:12.870 */
GO
CREATE TABLE [dbo].[LeadList](
	[Id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportCreateDate__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedAccountId] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedContactId] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RptCreateDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
