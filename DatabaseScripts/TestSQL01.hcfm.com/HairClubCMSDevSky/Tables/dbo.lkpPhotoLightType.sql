/* CreateDate: 05/06/2014 09:10:04.287 , ModifyDate: 12/29/2021 15:38:46.290 */
GO
CREATE TABLE [dbo].[lkpPhotoLightType](
	[PhotoLightTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PhotoLightTypeSortOrder] [int] NOT NULL,
	[PhotoLightTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoLightTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoLightType] PRIMARY KEY CLUSTERED
(
	[PhotoLightTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPhotoLightType] ADD  CONSTRAINT [DF_lkpPhotoLightType_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
