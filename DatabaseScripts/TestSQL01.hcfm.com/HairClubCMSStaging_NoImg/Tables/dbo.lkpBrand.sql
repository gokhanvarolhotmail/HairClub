/* CreateDate: 04/08/2013 21:55:37.220 , ModifyDate: 03/04/2022 16:09:12.533 */
GO
CREATE TABLE [dbo].[lkpBrand](
	[BrandID] [int] NOT NULL,
	[BrandSortOrder] [int] NOT NULL,
	[BrandDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpBrand] PRIMARY KEY CLUSTERED
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpBrand] ADD  CONSTRAINT [DF_lkpBrand_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
