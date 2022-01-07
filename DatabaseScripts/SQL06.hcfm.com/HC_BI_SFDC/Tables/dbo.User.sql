/* CreateDate: 10/04/2019 14:09:30.530 , ModifyDate: 01/07/2022 00:17:46.817 */
GO
CREATE TABLE [dbo].[User](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FirstName] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Username] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserCode__c] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Alias] [nvarchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Team] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
