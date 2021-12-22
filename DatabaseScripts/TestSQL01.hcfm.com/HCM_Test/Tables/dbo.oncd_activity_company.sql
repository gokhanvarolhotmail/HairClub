/* CreateDate: 01/18/2005 09:34:08.140 , ModifyDate: 09/10/2019 22:43:13.113 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity_company](
	[activity_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_company] PRIMARY KEY CLUSTERED
(
	[activity_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_company_i2] ON [dbo].[oncd_activity_company]
(
	[activity_id] ASC,
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [activity_activity_com_139] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [activity_activity_com_139]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [company_activity_com_140] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [company_activity_com_140]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [user_activity_com_453] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [user_activity_com_453]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [user_activity_com_454] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [user_activity_com_454]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-10-10
-- Description:	Set activity Time Zone based on primary company primary address
-- =============================================
CREATE TRIGGER [dbo].[pso_SetActivityTZ_Company]
   ON  [dbo].[oncd_activity_company]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @activity_id	nchar(10)
	DECLARE @company_id		nchar(10)
	DECLARE @tz_code		nchar(10)

	DECLARE ins CURSOR FOR
		SELECT
				i.activity_id,
				i.company_id
			FROM inserted i
			INNER JOIN oncd_activity (NOLOCK) a ON a.activity_id = i.activity_id
			LEFT OUTER JOIN deleted d ON d.activity_company_id = i.activity_company_id
			WHERE
				((i.primary_flag = 'Y' AND (d.primary_flag IS NULL OR d.primary_flag = 'N'))
				OR
				(d.sort_order IS NULL OR d.sort_order <> i.sort_order))
				AND a.action_code IN ('APPOINT', 'BEBACK', 'INHOUSE')
				AND a.result_code IS NULL

	OPEN ins
	FETCH ins INTO @activity_id, @company_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @tz_code = NULL
		SELECT TOP 1 @tz_code = co.time_zone_code
			FROM onca_county co
			INNER JOIN onca_zip z ON z.county_code = co.county_code
			INNER JOIN oncd_company_address (NOLOCK) ca ON ca.zip_code = z.zip_code
			WHERE ca.company_id = @company_id --AND ca.primary_flag = 'Y'
			AND co.time_zone_code IS NOT NULL
			ORDER BY ca.primary_flag DESC, ca.sort_order

		IF @tz_code IS NOT NULL
			UPDATE oncd_activity SET cst_time_zone_code = @tz_code WHERE activity_id = @activity_id
		ELSE
			UPDATE oncd_activity SET cst_time_zone_code = 'UNK' WHERE activity_id = @activity_id

		FETCH ins INTO @activity_id, @company_id
	END
	CLOSE ins
	DEALLOCATE ins

END
GO
ALTER TABLE [dbo].[oncd_activity_company] ENABLE TRIGGER [pso_SetActivityTZ_Company]
GO
