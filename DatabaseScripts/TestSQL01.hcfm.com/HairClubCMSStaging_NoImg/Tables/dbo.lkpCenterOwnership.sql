/* CreateDate: 03/03/2009 13:24:04.663 , ModifyDate: 12/03/2021 10:24:48.657 */
GO
CREATE TABLE [dbo].[lkpCenterOwnership](
	[CenterOwnershipID] [int] NOT NULL,
	[CenterOwnershipSortOrder] [int] NOT NULL,
	[CenterOwnershipDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterOwnershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CorporateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[PostalCode] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClientExperienceSurveyEnabled] [bit] NOT NULL,
	[ClientExperienceSurveyDelayDays] [int] NULL,
 CONSTRAINT [PK_lkpCenterOwnership] PRIMARY KEY CLUSTERED
(
	[CenterOwnershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpCenterOwnership] ADD  DEFAULT ((0)) FOR [IsClientExperienceSurveyEnabled]
GO
ALTER TABLE [dbo].[lkpCenterOwnership]  WITH CHECK ADD  CONSTRAINT [FK_lkpCenterOwnership_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[lkpCenterOwnership] CHECK CONSTRAINT [FK_lkpCenterOwnership_lkpCountry]
GO
ALTER TABLE [dbo].[lkpCenterOwnership]  WITH CHECK ADD  CONSTRAINT [FK_lkpCenterOwnership_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[lkpCenterOwnership] CHECK CONSTRAINT [FK_lkpCenterOwnership_lkpState]
GO
