/* CreateDate: 07/19/2012 13:57:51.360 , ModifyDate: 07/19/2012 13:57:51.360 */
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
