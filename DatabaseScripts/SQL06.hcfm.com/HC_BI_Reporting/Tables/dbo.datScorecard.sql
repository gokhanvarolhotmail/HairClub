/* CreateDate: 04/22/2021 16:28:17.003 , ModifyDate: 04/22/2021 16:28:17.153 */
GO
CREATE TABLE [dbo].[datScorecard](
	[OrganizationKey] [int] NULL,
	[Organization] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ID] [int] NULL,
	[MeasureID] [int] NULL,
	[Measure] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeasureType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] [date] NULL,
	[Value] [decimal](18, 4) NULL,
	[Threshold1] [decimal](18, 4) NULL,
	[Threshold2] [decimal](18, 4) NULL,
	[Threshold3] [decimal](18, 4) NULL,
	[Threshold4] [decimal](18, 4) NULL
) ON [PRIMARY]
GO
