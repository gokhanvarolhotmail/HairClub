/* CreateDate: 10/24/2011 13:49:05.410 , ModifyDate: 11/29/2012 15:32:15.757 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactSurgeryCloseoutEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactSurgeryCloseoutEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSurgeryCloseoutEmployee]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10/24/11  KMurdoch     Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, MissingDate	datetime
					, RecordID varchar(150)
					, CreatedDate datetime
					, UpdateDate datetime
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @MissingDate				datetime

 	SET @TableName = N'[bi_cms_dds].[FactSurgeryCloseoutEmployee]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SurgeryCloseoutEmployeeGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSurgeryCloseoutEmployee] SRC WITH (NOLOCK)
		WHERE src.[SurgeryCloseoutEmployeeGUID] NOT
		IN (
				SELECT [SurgeryCloseoutEmployeeSSID]
				FROM [bi_health].[synHC_DDS_FactSurgeryCloseoutEmployee] DW WITH (NOLOCK)

				)


RETURN
END
GO
