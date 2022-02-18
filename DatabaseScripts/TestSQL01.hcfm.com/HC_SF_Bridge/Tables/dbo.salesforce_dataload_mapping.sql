/* CreateDate: 09/24/2017 01:46:11.927 , ModifyDate: 11/13/2017 11:46:31.540 */
GO
CREATE TABLE [dbo].[salesforce_dataload_mapping](
	[sf_object_id] [int] NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[batch_date] [datetime] NULL,
PRIMARY KEY CLUSTERED
(
	[sf_object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
