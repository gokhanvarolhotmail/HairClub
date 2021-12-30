/* CreateDate: 03/17/2020 15:16:47.863 , ModifyDate: 06/15/2020 14:17:43.100 */
GO
CREATE TABLE [dbo].[datCenterClosure](
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [int] NULL,
	[ClosureDate] [datetime] NULL,
	[ReopenDate] [datetime] NULL
) ON [PRIMARY]
GO
