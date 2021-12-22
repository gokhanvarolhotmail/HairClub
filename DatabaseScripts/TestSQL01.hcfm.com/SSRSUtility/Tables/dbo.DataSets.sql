/* CreateDate: 03/12/2019 09:24:29.707 , ModifyDate: 03/12/2019 09:24:29.707 */
GO
CREATE TABLE [dbo].[DataSets](
	[ReportName] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DataSetName] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DataSourceName] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommandText] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
