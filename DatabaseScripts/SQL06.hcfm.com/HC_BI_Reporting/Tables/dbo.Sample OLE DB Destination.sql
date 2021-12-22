/* CreateDate: 11/15/2017 12:05:09.820 , ModifyDate: 11/15/2017 12:05:09.820 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sample OLE DB Destination](
	[PayPeriodID] [real] NULL,
	[StartDate] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EndDate] [date] NULL,
	[PayDate] [real] NULL,
	[PayPeriodOutputAlias] [int] NULL
) ON [PRIMARY]
GO
