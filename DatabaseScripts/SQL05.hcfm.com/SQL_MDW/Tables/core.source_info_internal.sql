/* CreateDate: 01/03/2014 07:07:45.900 , ModifyDate: 01/03/2014 07:07:48.600 */
GO
CREATE TABLE [core].[source_info_internal](
	[source_id] [int] IDENTITY(1,1) NOT NULL,
	[collection_set_uid] [uniqueidentifier] NOT NULL,
	[instance_name] [sysname] COLLATE Latin1_General_CI_AI NOT NULL,
	[days_until_expiration] [smallint] NOT NULL,
	[operator] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_source_info_internal] PRIMARY KEY CLUSTERED
(
	[source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_collection_set_uid_instance_name] UNIQUE NONCLUSTERED
(
	[collection_set_uid] ASC,
	[instance_name] ASC,
	[operator] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
