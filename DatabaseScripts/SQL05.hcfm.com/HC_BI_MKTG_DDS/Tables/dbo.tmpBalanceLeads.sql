/* CreateDate: 07/16/2020 10:24:31.427 , ModifyDate: 07/16/2020 10:24:31.427 */
GO
CREATE TABLE [dbo].[tmpBalanceLeads](
	[CaseSafeID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead ID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center Number] [float] NULL,
	[First Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company / Account] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead Source] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rating] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead Owner] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Create Date] [datetime] NULL
) ON [FG1]
GO
