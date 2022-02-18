/* CreateDate: 08/27/2008 12:14:07.397 , ModifyDate: 01/31/2022 08:32:31.887 */
GO
CREATE TABLE [dbo].[lkpPermBrand](
	[PermBrandID] [int] NOT NULL,
	[PermBrandSortOrder] [int] NOT NULL,
	[PermBrandDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PermBrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpPermBrand] PRIMARY KEY CLUSTERED
(
	[PermBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPermBrand] ADD  CONSTRAINT [DF_lkpPermBrand_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
