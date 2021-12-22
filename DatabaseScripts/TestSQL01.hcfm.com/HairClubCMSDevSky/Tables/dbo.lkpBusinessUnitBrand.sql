/* CreateDate: 08/27/2008 11:28:45.303 , ModifyDate: 12/07/2021 16:20:16.010 */
GO
CREATE TABLE [dbo].[lkpBusinessUnitBrand](
	[BusinessUnitBrandID] [int] NOT NULL,
	[BusinessUnitBrandSortOrder] [int] NOT NULL,
	[BusinessUnitBrandDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitBrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpBusinessUnitBrand] PRIMARY KEY CLUSTERED
(
	[BusinessUnitBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpBusinessUnitBrand] ADD  CONSTRAINT [DF_lkpBusinessUnitBrand_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
