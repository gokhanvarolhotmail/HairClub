/* CreateDate: 05/13/2010 12:51:03.187 , ModifyDate: 05/13/2010 15:03:44.527 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimRevenueGroup] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimRevenueGroup]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimRevenueGroup]()
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

 	SET @TableName = N'[bi_ent_dds].[DimRevenueGroup]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[RevenueGroupID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpRevenueGroup] SRC
		WHERE src.[RevenueGroupID] NOT
		IN (
				SELECT DW.[RevenueGroupSSID]
				FROM [bi_health].[synHC_DDS_DimRevenueGroup] DW WITH (NOLOCK)
				)


RETURN
END
GO
