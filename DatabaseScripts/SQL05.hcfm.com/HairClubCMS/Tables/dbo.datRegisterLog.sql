/* CreateDate: 05/05/2020 17:42:51.783 , ModifyDate: 05/05/2020 17:43:12.980 */
GO
CREATE TABLE [dbo].[datRegisterLog](
	[RegisterLogGUID] [uniqueidentifier] NOT NULL,
	[RegisterID] [int] NOT NULL,
	[EndOfDayGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[OpeningBalance] [money] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterLog] PRIMARY KEY CLUSTERED
(
	[RegisterLogGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
