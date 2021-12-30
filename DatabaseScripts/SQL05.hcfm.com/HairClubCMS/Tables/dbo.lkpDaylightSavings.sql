/* CreateDate: 05/05/2020 17:42:53.697 , ModifyDate: 05/05/2020 17:43:15.990 */
GO
CREATE TABLE [dbo].[lkpDaylightSavings](
	[DaylightSavingsID] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[DSTStartDate] [datetime] NOT NULL,
	[DSTEndDate] [datetime] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpDaylightSavings] PRIMARY KEY CLUSTERED
(
	[DaylightSavingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
