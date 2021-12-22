/* CreateDate: 12/04/2008 15:43:18.123 , ModifyDate: 12/04/2008 15:43:18.640 */
GO
CREATE TABLE [dbo].[cstd_tmp_dnc_return](
	[area_code] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dnc_flag] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
