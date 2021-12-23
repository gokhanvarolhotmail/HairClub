/* CreateDate: 08/27/2008 11:31:38.010 , ModifyDate: 12/03/2021 10:24:48.640 */
GO
CREATE TABLE [dbo].[lkpColorFormulaSize](
	[ColorFormulaSizeID] [int] NOT NULL,
	[ColorBrandID] [int] NULL,
	[ColorFormulaSizeSortOrder] [int] NOT NULL,
	[ColorFormulaSizeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColorFormulaSizeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpColorFormulaSize] PRIMARY KEY CLUSTERED
(
	[ColorFormulaSizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpColorFormulaSize] ADD  CONSTRAINT [DF_lkpColorFormulaSize_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpColorFormulaSize]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpColorFormulaSize_lkpColorBrand] FOREIGN KEY([ColorBrandID])
REFERENCES [dbo].[lkpColorBrand] ([ColorBrandID])
GO
ALTER TABLE [dbo].[lkpColorFormulaSize] CHECK CONSTRAINT [FK_lkpColorFormulaSize_lkpColorBrand]
GO
