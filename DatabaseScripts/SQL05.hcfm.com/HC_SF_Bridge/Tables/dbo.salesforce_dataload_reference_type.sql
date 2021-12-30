/* CreateDate: 09/21/2017 17:45:37.103 , ModifyDate: 09/21/2017 17:48:19.940 */
GO
CREATE TABLE [dbo].[salesforce_dataload_reference_type](
	[sf_object_id] [int] NULL,
	[description] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [idx_salesforce_dataload_reference_type_sf_object_id] ON [dbo].[salesforce_dataload_reference_type]
(
	[sf_object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
