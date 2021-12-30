/* CreateDate: 05/12/2010 11:38:49.453 , ModifyDate: 05/13/2010 14:49:04.240 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairLossType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairLossType]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairLossType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairLossType]'


	INSERT INTO @tbl
		SELECT @TableName, HairLossTypeKey, CAST(HairLossTypeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairLossType] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimHairLossType] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
