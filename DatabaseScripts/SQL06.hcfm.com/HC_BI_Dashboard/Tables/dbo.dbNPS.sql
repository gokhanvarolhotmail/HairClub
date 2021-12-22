/* CreateDate: 08/28/2020 15:44:00.637 , ModifyDate: 08/28/2020 15:44:00.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbNPS](
	[CenterKey] [int] NULL,
	[FullDate] [datetime] NULL,
	[FirstContactNPS] [int] NULL,
	[ConsultNPS] [int] NULL,
	[NewClientNPS] [int] NULL,
	[RecurringClientNPS] [int] NULL
) ON [PRIMARY]
GO
