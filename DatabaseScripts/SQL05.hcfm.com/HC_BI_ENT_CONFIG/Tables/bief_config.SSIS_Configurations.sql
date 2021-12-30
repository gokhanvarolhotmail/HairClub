/* CreateDate: 05/01/2010 23:05:34.407 , ModifyDate: 05/01/2010 23:05:34.407 */
GO
CREATE TABLE [bief_config].[SSIS_Configurations](
	[ConfigurationFilter] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConfiguredValue] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackagePath] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConfiguredValueType] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
