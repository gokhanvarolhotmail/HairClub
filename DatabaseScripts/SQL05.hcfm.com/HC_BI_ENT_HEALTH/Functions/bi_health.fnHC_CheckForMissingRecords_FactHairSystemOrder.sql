/* CreateDate: 10/25/2011 14:12:03.793 , ModifyDate: 11/29/2012 15:27:34.580 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactHairSystemOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactHairSystemOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactHairSystemOrder]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactHairSystemOrder]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.HairSystemOrderGUID as varchar(150)) AS RecordID
			, src.CreateDate AS CreatedDate
			, src.LastUpdate AS UpdateDate
		FROM [bi_health].synHC_SRC_TBL_CMS_datHairSystemOrder SRC WITH (NOLOCK)
		WHERE src.HairSystemOrderGUID NOT
		IN (
				SELECT DW.HairSystemOrderSSID
				FROM [bi_health].[synHC_DDS_FactHairSystemOrder] DW WITH (NOLOCK)
				)


RETURN
END
GO
