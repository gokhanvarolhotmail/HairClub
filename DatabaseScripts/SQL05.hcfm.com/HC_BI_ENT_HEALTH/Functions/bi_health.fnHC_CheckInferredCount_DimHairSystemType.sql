/* CreateDate: 10/25/2011 08:36:00.580 , ModifyDate: 10/25/2011 08:36:00.580 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemType]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DDimHairSystemType]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemType]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemTypeKey, CAST(HairSystemTypeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemType] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
