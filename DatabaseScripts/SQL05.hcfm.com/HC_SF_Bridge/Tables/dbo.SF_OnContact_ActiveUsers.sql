/* CreateDate: 10/06/2017 11:19:55.920 , ModifyDate: 10/06/2017 11:19:55.920 */
GO
CREATE TABLE [dbo].[SF_OnContact_ActiveUsers](
	[sf_Id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TM_Num] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[sf_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
