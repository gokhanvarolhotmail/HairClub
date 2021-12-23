/* CreateDate: 01/18/2005 09:34:08.873 , ModifyDate: 09/10/2019 22:43:25.563 */
/* ***HasTriggers*** TriggerCount: 3 */
GO
CREATE TABLE [dbo].[oncd_contact_company](
	[contact_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[reports_to_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[department_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[internal_title_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_preferred_center_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_company] PRIMARY KEY CLUSTERED
(
	[contact_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_company_i2] ON [dbo].[oncd_contact_company]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([company_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_company_i3] ON [dbo].[oncd_contact_company]
(
	[company_id] ASC,
	[company_role_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_company_test1] ON [dbo].[oncd_contact_company]
(
	[primary_flag] ASC
)
INCLUDE([contact_company_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [company_contact_comp_97] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [company_contact_comp_97]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [company_role_contact_comp_587] FOREIGN KEY([company_role_code])
REFERENCES [dbo].[onca_company_role] ([company_role_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [company_role_contact_comp_587]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [contact_contact_comp_331] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [contact_contact_comp_331]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [contact_contact_comp_96] FOREIGN KEY([reports_to_contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [contact_contact_comp_96]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [department_contact_comp_588] FOREIGN KEY([department_code])
REFERENCES [dbo].[onca_department] ([department_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [department_contact_comp_588]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [internal_tit_contact_comp_589] FOREIGN KEY([internal_title_code])
REFERENCES [dbo].[onca_internal_title] ([internal_title_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [internal_tit_contact_comp_589]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [user_contact_comp_585] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [user_contact_comp_585]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [user_contact_comp_586] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [user_contact_comp_586]
GO
-- ============================================================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 02/17/09
-- Description:	Ensure contact has only one primary center or cube job fails
-- Modify Date: 10 February 2011
-- Description: Update the Contact's updated_date and updated_by_user_code when
--              the Contact Company record is updated.
--              General formatting.
-- ============================================================================

CREATE TRIGGER [dbo].[pso_oncd_contact_company]
   ON  [dbo].[oncd_contact_company]
   AFTER insert, update AS
BEGIN

	IF CURSOR_STATUS('local', 'contact_company_data') >= 0
	BEGIN
		CLOSE contact_company_data
		DEALLOCATE contact_company_data
	END

	IF CURSOR_STATUS('global', 'contact_company_data') >= 0
	BEGIN
		CLOSE contact_company_data
		DEALLOCATE contact_company_data
	END

	DECLARE @contactId			NCHAR(10)
	DECLARE @primaryFlag		NCHAR(1)
	DECLARE @contactCompanyId	NCHAR(10)
	DECLARE @updatedDate		DATETIME
	DECLARE @updatedByUserCode	NCHAR(20)

	IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
		INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

	DECLARE contact_company_data CURSOR FOR
		--SELECT top 1 contact_id, primary_flag, contact_company_id, updated_date, updated_by_user_code from Inserted
		SELECT contact_id, primary_flag, contact_company_id, updated_date, updated_by_user_code from Inserted

	OPEN contact_company_data

	FETCH NEXT FROM contact_company_data
		INTO @contactId, @primaryFlag, @contactCompanyId, @updatedDate, @updatedByUserCode

	WHILE (@@fetch_status = 0)
	BEGIN
		--If incoming record is primary, set all other contact company records primary to N
		--and then update this record to primary
		IF (@primaryFlag = 'Y')
		BEGIN
				UPDATE oncd_contact_company
				SET primary_flag = 'N'
				WHERE contact_id = @contactId

				UPDATE oncd_contact_company
				SET primary_flag = 'Y'
				WHERE contact_company_id = @contactCompanyId
		END

		UPDATE oncd_contact
		SET	updated_date = @updatedDate,
			updated_by_user_code = @updatedByUserCode
		WHERE contact_id = @contactId

		FETCH NEXT FROM contact_company_data
			INTO @contactId, @primaryFlag, @contactCompanyId, @updatedDate, @updatedByUserCode
	END
	CLOSE contact_company_data
	DEALLOCATE contact_company_data
END
GO
ALTER TABLE [dbo].[oncd_contact_company] ENABLE TRIGGER [pso_oncd_contact_company]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_company_after_delete]
   ON  [dbo].[oncd_contact_company]
   AFTER DELETE
AS
	UPDATE cstd_contact_flat SET
		primary_center_number = dbo.psoRemoveNonAlphaNumeric(com.cst_center_number),
		primary_center_name = com.company_name_1
	FROM deleted
	INNER JOIN oncd_contact con ON con.contact_id = deleted.contact_id
	LEFT OUTER JOIN oncd_contact_company cc on cc.contact_id = con.contact_id
		AND cc.primary_flag = 'Y'
	LEFT OUTER JOIN oncd_company com ON com.company_id = cc.company_id
	WHERE cstd_contact_flat.contact_id = deleted.contact_id
GO
ALTER TABLE [dbo].[oncd_contact_company] ENABLE TRIGGER [pso_oncd_contact_company_after_delete]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_company_after_insert_update]
   ON  [dbo].[oncd_contact_company]
   AFTER INSERT, UPDATE
AS
	UPDATE cstd_contact_flat SET
		primary_center_number = dbo.psoRemoveNonAlphaNumeric(com.cst_center_number),
		primary_center_name = com.company_name_1
	FROM inserted
	INNER JOIN oncd_contact con ON con.contact_id = inserted.contact_id
	LEFT OUTER JOIN oncd_contact_company cc on cc.contact_id = con.contact_id
		AND cc.primary_flag = 'Y'
	LEFT OUTER JOIN oncd_company com ON com.company_id = cc.company_id
	WHERE cstd_contact_flat.contact_id = inserted.contact_id
GO
ALTER TABLE [dbo].[oncd_contact_company] ENABLE TRIGGER [pso_oncd_contact_company_after_insert_update]
GO
