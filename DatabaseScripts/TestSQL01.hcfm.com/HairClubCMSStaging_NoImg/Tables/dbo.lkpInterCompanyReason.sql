/* CreateDate: 10/23/2008 11:15:33.473 , ModifyDate: 01/04/2022 10:56:36.760 */
GO
CREATE TABLE [dbo].[lkpInterCompanyReason](
	[InterCompanyReasonID] [int] NOT NULL,
	[InterCompanyReasonSortOrder] [int] NOT NULL,
	[InterCompanyReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InterCompanyReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInterCompanyReason] PRIMARY KEY CLUSTERED
(
	[InterCompanyReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInterCompanyReason] ADD  CONSTRAINT [DF_lkpInterCompanyReason_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
