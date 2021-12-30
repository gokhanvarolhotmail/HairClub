/* CreateDate: 10/03/2019 23:03:39.913 , ModifyDate: 10/03/2019 23:03:44.920 */
GO
CREATE TABLE [bi_cms_dds].[DimActiveDirectoryGroup](
	[ActiveDirectoryGroupKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActiveDirectoryGroupSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimActiveDirectoryGroup] PRIMARY KEY CLUSTERED
(
	[ActiveDirectoryGroupKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
