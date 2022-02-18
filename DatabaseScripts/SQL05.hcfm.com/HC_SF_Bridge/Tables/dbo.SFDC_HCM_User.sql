/* CreateDate: 02/14/2022 15:07:17.287 , ModifyDate: 02/14/2022 15:07:17.287 */
GO
CREATE TABLE [dbo].[SFDC_HCM_User](
	[sf_Id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TM_Num] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
