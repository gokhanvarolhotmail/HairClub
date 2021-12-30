/* CreateDate: 05/05/2020 17:42:43.473 , ModifyDate: 05/05/2020 17:43:01.927 */
GO
CREATE TABLE [dbo].[cfgHairSystemLocation](
	[HairSystemLocationID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[CabinetNumber] [int] NULL,
	[DrawerNumber] [int] NULL,
	[BinNumber] [int] NULL,
	[NonstandardDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaximumQuantityPerLocation] [int] NULL,
	[HairSystemLocationDescriptionCalc]  AS (isnull([NonstandardDescription],(((('C:'+isnull(CONVERT([nvarchar],[CabinetNumber],(0)),'x'))+' D:')+isnull(CONVERT([nvarchar],[DrawerNumber],(0)),'x'))+' B:')+isnull(CONVERT([nvarchar],[BinNumber],(0)),'x'))),
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemLocation] PRIMARY KEY CLUSTERED
(
	[HairSystemLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
