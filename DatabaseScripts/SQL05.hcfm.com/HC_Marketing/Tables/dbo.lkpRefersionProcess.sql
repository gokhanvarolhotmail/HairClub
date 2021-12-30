/* CreateDate: 12/03/2019 15:34:36.367 , ModifyDate: 07/16/2021 13:26:06.557 */
GO
CREATE TABLE [dbo].[lkpRefersionProcess](
	[RefersionProcessID] [int] IDENTITY(1,1) NOT NULL,
	[RefersionProcessDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RefersionProcessDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpRefersionProcess] PRIMARY KEY CLUSTERED
(
	[RefersionProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRefersionProcess] ADD  CONSTRAINT [DF_lkpRefersionProcess_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
