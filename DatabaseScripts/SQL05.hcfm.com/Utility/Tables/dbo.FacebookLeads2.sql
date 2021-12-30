/* CreateDate: 12/22/2020 22:40:06.423 , ModifyDate: 12/22/2020 22:40:06.423 */
GO
CREATE TABLE [dbo].[FacebookLeads2](
	[Source_Code_Legacy__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [char](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate1] [datetime] NULL,
	[CreateDateFormattedTextAndFixedTime] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
