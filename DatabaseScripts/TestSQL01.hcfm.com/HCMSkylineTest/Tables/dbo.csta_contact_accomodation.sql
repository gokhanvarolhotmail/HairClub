/* CreateDate: 01/24/2017 16:00:46.023 , ModifyDate: 01/24/2017 16:00:46.063 */
GO
CREATE TABLE [dbo].[csta_contact_accomodation](
	[contact_accomodation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_contact_accomodation] PRIMARY KEY CLUSTERED
(
	[contact_accomodation_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
