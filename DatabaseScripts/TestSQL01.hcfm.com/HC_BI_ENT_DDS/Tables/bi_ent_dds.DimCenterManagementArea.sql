/* CreateDate: 12/29/2016 14:47:30.420 , ModifyDate: 09/16/2019 09:25:18.167 */
GO
CREATE TABLE [bi_ent_dds].[DimCenterManagementArea](
	[CenterManagementAreaKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterManagementAreaSSID] [int] NOT NULL,
	[CenterManagementAreaSortOrder] [int] NOT NULL,
	[CenterManagementAreaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterManagementAreaDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OperationsManagerSSID] [uniqueidentifier] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimCenterManagementArea] PRIMARY KEY CLUSTERED
(
	[CenterManagementAreaKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
