/* CreateDate: 05/02/2010 01:09:14.590 , ModifyDate: 05/02/2010 01:09:14.590 */
GO
CREATE TABLE [bief_config].[SSIS_Configurations](
	[ConfigurationFilter] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConfiguredValue] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackagePath] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConfiguredValueType] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
