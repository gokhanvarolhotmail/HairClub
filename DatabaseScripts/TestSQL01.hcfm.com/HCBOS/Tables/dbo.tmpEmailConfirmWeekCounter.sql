/* CreateDate: 01/11/2007 14:38:29.937 , ModifyDate: 05/08/2010 02:30:11.667 */
GO
CREATE TABLE [dbo].[tmpEmailConfirmWeekCounter](
	[WeekCounterId] [int] IDENTITY(1,1) NOT NULL,
	[WeekOf] [datetime] NULL,
	[GoBackWeeks] [int] NULL,
	[SendCount] [int] NULL,
	[Completed] [bit] NULL,
 CONSTRAINT [PK_tmpEmailConfirmWeekCounter] PRIMARY KEY CLUSTERED
(
	[WeekCounterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
