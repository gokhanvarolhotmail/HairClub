/* CreateDate: 05/05/2020 17:42:47.380 , ModifyDate: 05/05/2020 17:43:06.277 */
GO
CREATE TABLE [dbo].[datEndOfDay](
	[EndOfDayGUID] [uniqueidentifier] NOT NULL,
	[EndOfDayDate] [datetime] NOT NULL,
	[CenterID] [int] NOT NULL,
	[DepositID_Temp] [int] NULL,
	[DepositNumber] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CloseDate] [datetime] NULL,
	[IsExportedToQuickBooks] [bit] NULL,
	[CloseNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datEndOfDay] PRIMARY KEY CLUSTERED
(
	[EndOfDayGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
