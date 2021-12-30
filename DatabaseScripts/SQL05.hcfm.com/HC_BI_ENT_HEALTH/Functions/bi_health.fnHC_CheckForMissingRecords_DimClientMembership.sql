/* CreateDate: 05/12/2010 16:43:21.890 , ModifyDate: 11/29/2012 15:21:22.457 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClientMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembership]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[ClientMembershipGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datClientMembership] SRC WITH (NOLOCK)
		WHERE src.[ClientMembershipGUID] NOT
		IN (
				SELECT DW.[ClientMembershipSSID]
				FROM [bi_health].[synHC_DDS_DimClientMembership] DW WITH (NOLOCK)
				)


RETURN
END
GO
