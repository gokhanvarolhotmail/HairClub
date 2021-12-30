/* CreateDate: 05/05/2020 17:42:55.273 , ModifyDate: 05/05/2020 17:43:16.163 */
GO
CREATE TABLE [dbo].[lkpSurgeryCenterType](
	[SurgeryCenterTypeID] [int] NOT NULL,
	[SurgeryCenterTypeSortOrder] [int] NOT NULL,
	[SurgeryCenterTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SurgeryCenterTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpSurgeryCenterType] PRIMARY KEY CLUSTERED
(
	[SurgeryCenterTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
