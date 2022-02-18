/* CreateDate: 02/17/2022 13:46:33.650 , ModifyDate: 02/17/2022 13:46:33.650 */
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
