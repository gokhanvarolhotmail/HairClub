/* CreateDate: 03/21/2022 16:10:17.523 , ModifyDate: 03/21/2022 16:10:17.523 */
GO
CREATE TABLE [dbo].[Account](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PersonContactId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountNumber] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
