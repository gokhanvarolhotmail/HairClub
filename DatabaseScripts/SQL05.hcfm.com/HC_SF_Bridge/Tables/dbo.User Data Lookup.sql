/* CreateDate: 02/14/2022 14:20:25.283 , ModifyDate: 02/14/2022 14:20:25.283 */
GO
CREATE TABLE [dbo].[User Data Lookup](
	[Name] [nvarchar](121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserCode__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Name] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dest_UserCode__c] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
