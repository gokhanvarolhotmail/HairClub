CREATE TABLE [bi_ent_dds].[DimCenterManagementArea](
	[CenterManagementAreaKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterManagementAreaSSID] [int] NOT NULL,
	[CenterManagementAreaSortOrder] [int] NOT NULL,
	[CenterManagementAreaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterManagementAreaDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OperationsManagerSSID] [uniqueidentifier] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimCenterManagementArea] ON [bi_ent_dds].[DimCenterManagementArea]
(
	[CenterManagementAreaKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
