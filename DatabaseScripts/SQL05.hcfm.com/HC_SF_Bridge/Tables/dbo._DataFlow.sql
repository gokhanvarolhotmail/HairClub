/* CreateDate: 10/27/2017 09:27:46.197 , ModifyDate: 10/27/2017 09:27:46.197 */
GO
CREATE TABLE [dbo].[_DataFlow](
	[DataFlowKey] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LSET] [datetime] NULL,
	[CET] [datetime] NULL,
 CONSTRAINT [PK_DataFlow] PRIMARY KEY CLUSTERED
(
	[DataFlowKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Successful Extraction Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_DataFlow', @level2type=N'COLUMN',@level2name=N'LSET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Current Extraction Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'_DataFlow', @level2type=N'COLUMN',@level2name=N'CET'
GO
