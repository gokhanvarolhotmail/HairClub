/* CreateDate: 02/26/2017 22:35:10.653 , ModifyDate: 01/04/2022 10:56:36.727 */
GO
CREATE TABLE [dbo].[datTechnicalProfileStylingProduct](
	[TechnicalProfileStylingProductID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileStylingProduct] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileStylingProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileStylingProduct_TechnicalProfileID_SalesCodeID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[SalesCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileStylingProduct]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileStylingProduct_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileStylingProduct] CHECK CONSTRAINT [FK_datTechnicalProfileStylingProduct_cfgSalesCode]
GO
ALTER TABLE [dbo].[datTechnicalProfileStylingProduct]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileStylingProduct_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileStylingProduct] CHECK CONSTRAINT [FK_datTechnicalProfileStylingProduct_datTechnicalProfile]
GO
