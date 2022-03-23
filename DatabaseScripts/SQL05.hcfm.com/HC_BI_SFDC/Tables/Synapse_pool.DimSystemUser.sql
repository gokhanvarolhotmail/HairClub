/* CreateDate: 03/21/2022 07:50:18.013 , ModifyDate: 03/21/2022 13:43:22.863 */
GO
CREATE TABLE [Synapse_pool].[DimSystemUser](
	[UserKey] [int] NULL,
	[UserId] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserLogin] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserName] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyName] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TeamName] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cONEctUserLogin] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cONEctGUID] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hash] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
