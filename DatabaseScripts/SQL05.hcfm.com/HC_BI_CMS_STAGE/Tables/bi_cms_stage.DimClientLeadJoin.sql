/* CreateDate: 05/23/2012 15:56:24.493 , ModifyDate: 05/07/2018 14:51:42.460 */
GO
CREATE TABLE [bi_cms_stage].[DimClientLeadJoin](
	[ContactSSID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG1]
GO
