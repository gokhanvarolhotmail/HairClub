/* CreateDate: 09/25/2006 11:29:50.750 , ModifyDate: 09/25/2006 11:29:50.750 */
GO
CREATE TABLE [dbo].[DNC_OUT_OLD](
	[DNC_OUT_ID] [uniqueidentifier] NOT NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastContactDate] [datetime] NULL,
	[LastSaleDate] [datetime] NULL,
	[FileCreationDate] [datetime] NULL,
	[DNC] [bit] NULL,
	[EBRExpiration] [datetime] NULL,
	[Sent] [bit] NULL,
	[LastUpdate] [datetime] NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
