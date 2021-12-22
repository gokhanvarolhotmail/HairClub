/* CreateDate: 08/27/2008 12:23:45.403 , ModifyDate: 12/07/2021 16:20:15.857 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSurgeryCenterType] ADD  CONSTRAINT [DF_lkpSurgeryCenterType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
