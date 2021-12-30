/* CreateDate: 05/12/2010 16:46:30.967 , ModifyDate: 11/29/2012 15:23:22.903 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimMembership]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[MembershipID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_cfgMembership] SRC WITH (NOLOCK)
		WHERE src.[MembershipID] NOT
		IN (
				SELECT DW.[MembershipSSID]
				FROM [bi_health].[synHC_DDS_DimMembership] DW WITH (NOLOCK)
				)


RETURN
END
GO
