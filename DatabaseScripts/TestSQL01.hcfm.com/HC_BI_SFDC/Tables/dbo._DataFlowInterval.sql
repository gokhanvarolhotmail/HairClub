/* CreateDate: 02/13/2018 09:39:58.840 , ModifyDate: 01/21/2022 14:26:44.783 */
GO
CREATE TABLE [dbo].[_DataFlowInterval](
	[DataFlowIntervalKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IntervalType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Interval] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
 CONSTRAINT [PK_DataFlowInterval] PRIMARY KEY CLUSTERED
(
	[DataFlowIntervalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[_DataFlowInterval] ADD  CONSTRAINT [DF__DataFlowInterval_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
