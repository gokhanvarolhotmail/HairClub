/* CreateDate: 03/21/2022 07:50:13.417 , ModifyDate: 03/21/2022 13:43:26.197 */
GO
CREATE TABLE [dbo].[lkpRefersionProcess](
	[RefersionProcessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
