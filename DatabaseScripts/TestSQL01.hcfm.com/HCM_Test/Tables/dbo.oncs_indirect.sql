/* CreateDate: 01/18/2005 09:34:18.967 , ModifyDate: 06/21/2012 10:04:45.343 */
GO
CREATE TABLE [dbo].[oncs_indirect](
	[indirect_date] [datetime] NOT NULL,
	[indirect_order] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [pk_oncs_indirect] PRIMARY KEY CLUSTERED
(
	[indirect_date] ASC,
	[indirect_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
