/* CreateDate: 03/21/2022 07:50:13.593 , ModifyDate: 03/21/2022 13:43:26.373 */
GO
CREATE TABLE [dbo].[lkpRefersionStatus](
	[RefersionStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefersionStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RefersionStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpRefersionStatus] PRIMARY KEY CLUSTERED
(
	[RefersionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRefersionStatus] ADD  CONSTRAINT [DF_lkpRefersionStatus_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
