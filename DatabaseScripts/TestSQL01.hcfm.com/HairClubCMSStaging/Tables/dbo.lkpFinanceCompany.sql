/* CreateDate: 08/27/2008 12:04:35.140 , ModifyDate: 05/26/2020 10:49:42.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpFinanceCompany](
	[FinanceCompanyID] [int] NOT NULL,
	[FinanceCompanySortOrder] [int] NOT NULL,
	[FinanceCompanyDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FinanceCompanyDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpFinanceCompany] PRIMARY KEY CLUSTERED
(
	[FinanceCompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpFinanceCompany] ADD  CONSTRAINT [DF_lkpFinanceCompany_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
