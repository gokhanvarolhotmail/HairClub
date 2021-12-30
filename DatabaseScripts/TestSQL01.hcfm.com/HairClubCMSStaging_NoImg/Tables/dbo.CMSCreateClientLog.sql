/* CreateDate: 05/08/2013 14:51:59.047 , ModifyDate: 05/08/2013 14:51:59.287 */
GO
CREATE TABLE [dbo].[CMSCreateClientLog](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCode] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessed] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ProcessStart] [datetime] NULL,
	[ProcessEnd] [datetime] NULL,
	[ErrorMessage] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
