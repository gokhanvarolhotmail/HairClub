/* CreateDate: 05/03/2010 12:08:47.717 , ModifyDate: 01/08/2021 15:21:36.200 */
GO
CREATE TABLE [bi_ent_dds].[DimGender](
	[GenderKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[GenderSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimGender] PRIMARY KEY CLUSTERED
(
	[GenderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimGender] ADD  CONSTRAINT [MSrepl_tran_version_default_BFA6826C_ADC7_48BE_A41E_4BD89774E498_213575799]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
