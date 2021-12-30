/* CreateDate: 05/05/2020 17:42:39.623 , ModifyDate: 05/05/2020 17:42:58.770 */
GO
CREATE TABLE [dbo].[cfgCenterManagementArea](
	[CenterManagementAreaID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterManagementAreaSortOrder] [int] NOT NULL,
	[CenterManagementAreaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterManagementAreaDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OperationsManagerGUID] [uniqueidentifier] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCenterManagementArea] PRIMARY KEY CLUSTERED
(
	[CenterManagementAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
