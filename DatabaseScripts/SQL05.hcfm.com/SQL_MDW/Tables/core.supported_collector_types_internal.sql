/* CreateDate: 01/03/2014 07:07:45.437 , ModifyDate: 01/03/2014 07:07:45.847 */
GO
CREATE TABLE [core].[supported_collector_types_internal](
	[collector_type_uid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_supported_collector_types_internal] PRIMARY KEY CLUSTERED
(
	[collector_type_uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
