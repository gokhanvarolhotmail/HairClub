/* CreateDate: 03/16/2022 09:07:05.073 , ModifyDate: 03/16/2022 09:07:05.073 */
GO
CREATE TABLE [dbo].[SFDC_HCM_User](
	[user_name] [nvarchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_sfdc_user_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Name] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_UserCode__c] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
