/* CreateDate: 05/03/2010 12:26:20.287 , ModifyDate: 08/12/2012 16:30:47.113 */
GO
CREATE TABLE [bief_stage].[_DataFlow](
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Successful Extraction Time' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DataFlow', @level2type=N'COLUMN',@level2name=N'LSET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Current Extraction Time' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DataFlow', @level2type=N'COLUMN',@level2name=N'CET'
GO
