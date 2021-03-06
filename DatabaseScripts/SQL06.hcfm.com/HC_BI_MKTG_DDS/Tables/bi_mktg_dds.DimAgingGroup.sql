/* CreateDate: 03/16/2016 15:19:21.293 , ModifyDate: 03/16/2016 15:19:21.293 */
GO
CREATE TABLE [bi_mktg_dds].[DimAgingGroup](
	[AgingGroupKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AGGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGMin] [int] NULL,
	[AGMax] [int] NULL,
 CONSTRAINT [PK_DimAgingGroup] PRIMARY KEY CLUSTERED
(
	[AgingGroupKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
