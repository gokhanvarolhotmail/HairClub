/* CreateDate: 05/12/2010 16:44:25.917 , ModifyDate: 10/25/2011 13:34:53.347 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimClientMembershipAccum] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimClientMembershipAccum]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClientMembershipAccum]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[ClientMembershipAccumGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datClientMembershipAccum] SRC
		WHERE src.[ClientMembershipAccumGUID] NOT
		IN (
				SELECT DW.[ClientMembershipAccumSSID]
				FROM [bi_health].[synHC_DDS_DimClientMembershipAccum] DW WITH (NOLOCK)
				)


RETURN
END
GO
