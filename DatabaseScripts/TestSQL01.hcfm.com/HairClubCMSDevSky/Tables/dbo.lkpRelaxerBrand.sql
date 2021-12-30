/* CreateDate: 08/27/2008 12:16:01.047 , ModifyDate: 12/29/2021 15:38:46.480 */
GO
CREATE TABLE [dbo].[lkpRelaxerBrand](
	[RelaxerBrandID] [int] NOT NULL,
	[RelaxerBrandSortOrder] [int] NOT NULL,
	[RelaxerBrandDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RelaxerBrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpRelaxerBrand] PRIMARY KEY CLUSTERED
(
	[RelaxerBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRelaxerBrand] ADD  CONSTRAINT [DF_lkpRelaxerBrand_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
