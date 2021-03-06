/* CreateDate: 07/27/2016 14:35:29.713 , ModifyDate: 07/27/2016 14:35:29.797 */
GO
CREATE TABLE [dbo].[cfgJob](
	[JobID] [int] IDENTITY(1,1) NOT NULL,
	[JobDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgJob] PRIMARY KEY CLUSTERED
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgJob] ADD  CONSTRAINT [DF_cfgJob_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
