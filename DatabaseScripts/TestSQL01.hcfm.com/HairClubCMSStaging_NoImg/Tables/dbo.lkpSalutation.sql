/* CreateDate: 08/27/2008 12:22:11.337 , ModifyDate: 03/04/2022 16:09:12.510 */
GO
CREATE TABLE [dbo].[lkpSalutation](
	[SalutationID] [int] NOT NULL,
	[SalutationSortOrder] [int] NOT NULL,
	[SalutationDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalutationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpSalutation] PRIMARY KEY CLUSTERED
(
	[SalutationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSalutation] ADD  CONSTRAINT [DF_lkpSalutation_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
