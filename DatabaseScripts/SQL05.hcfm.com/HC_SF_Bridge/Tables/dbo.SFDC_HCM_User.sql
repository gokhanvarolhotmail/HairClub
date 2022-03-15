/* CreateDate: 03/15/2022 10:17:36.070 , ModifyDate: 03/15/2022 10:17:36.070 */
GO
CREATE TABLE [dbo].[SFDC_HCM_User](
	[Name] [nvarchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserCode__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Name] [varchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_UserCode__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
