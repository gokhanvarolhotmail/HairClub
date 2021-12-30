/* CreateDate: 10/10/2012 14:50:39.087 , ModifyDate: 06/18/2014 01:39:27.933 */
GO
CREATE TABLE [dbo].[lkpPayPeriods](
	[PayPeriodKey] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PayDate] [datetime] NULL,
	[PayGroup] [smallint] NULL,
 CONSTRAINT [PK_lkpPayPeriods] PRIMARY KEY CLUSTERED
(
	[PayPeriodKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
