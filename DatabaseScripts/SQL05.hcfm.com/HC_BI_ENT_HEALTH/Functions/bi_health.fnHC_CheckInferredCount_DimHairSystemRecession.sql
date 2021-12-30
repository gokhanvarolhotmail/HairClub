/* CreateDate: 10/24/2011 14:26:20.567 , ModifyDate: 10/24/2011 14:26:20.567 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemRecession] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemRecession]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemRecession]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemRecession]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemRecessionkey, CAST(HairSystemRecessionSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemRecession] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
