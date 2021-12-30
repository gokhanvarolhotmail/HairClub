/* CreateDate: 12/11/2012 14:57:13.283 , ModifyDate: 03/01/2017 08:26:15.213 */
GO
CREATE TABLE [dbo].[datRegisterClose](
	[RegisterCloseGUID] [uniqueidentifier] NOT NULL,
	[DepositID_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[RegisterCloseDate] [datetime] NULL,
	[RegisterCloseTime] [datetime] NULL,
	[IsExportedToQuickBooks] [bit] NULL,
	[RegisterCloseNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterClose] PRIMARY KEY CLUSTERED
(
	[RegisterCloseGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
