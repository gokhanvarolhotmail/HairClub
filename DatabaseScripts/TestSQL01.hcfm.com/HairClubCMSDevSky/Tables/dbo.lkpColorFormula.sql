/* CreateDate: 08/27/2008 11:31:06.397 , ModifyDate: 12/07/2021 16:20:16.060 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpColorFormula](
	[ColorFormulaID] [int] NOT NULL,
	[ColorBrandID] [int] NULL,
	[ColorFormulaSortOrder] [int] NOT NULL,
	[ColorFormulaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColorFormulaDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpColorFormula] PRIMARY KEY CLUSTERED
(
	[ColorFormulaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpColorFormula] ADD  CONSTRAINT [DF_lkpColorFormula_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpColorFormula]  WITH CHECK ADD  CONSTRAINT [FK_lkpColorFormula_lkpColorBrand] FOREIGN KEY([ColorBrandID])
REFERENCES [dbo].[lkpColorBrand] ([ColorBrandID])
GO
ALTER TABLE [dbo].[lkpColorFormula] CHECK CONSTRAINT [FK_lkpColorFormula_lkpColorBrand]
GO
