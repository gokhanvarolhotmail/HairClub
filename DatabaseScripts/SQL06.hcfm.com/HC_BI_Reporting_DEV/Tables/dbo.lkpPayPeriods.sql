/* CreateDate: 07/19/2012 13:57:51.360 , ModifyDate: 07/19/2012 13:57:51.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpPayPeriods](
	[PayPeriodID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PayDate] [datetime] NULL,
	[PayGroup] [smallint] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
