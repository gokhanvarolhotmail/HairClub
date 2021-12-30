/* CreateDate: 02/27/2017 09:26:21.773 , ModifyDate: 02/27/2017 09:26:21.773 */
GO
CREATE TABLE [dbo].[tmpCMSUpdate](
	[CMSUpdateId] [int] NOT NULL,
	[CenterId] [int] NOT NULL,
	[Client_no] [int] NULL,
	[HairSystemOrderNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CMS25Transact_no] [int] NULL,
	[CMS25TransactionDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[IsSuccessful] [bit] NULL,
	[ErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorCode] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
