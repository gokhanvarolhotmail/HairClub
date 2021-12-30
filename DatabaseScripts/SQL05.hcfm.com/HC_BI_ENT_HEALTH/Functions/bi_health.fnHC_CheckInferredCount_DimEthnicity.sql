/* CreateDate: 05/12/2010 11:29:01.470 , ModifyDate: 05/13/2010 14:47:59.703 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimEthnicity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimEthnicity]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimEthnicity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimEthnicity]'


	INSERT INTO @tbl
		SELECT @TableName, EthnicityKey, CAST(EthnicitySSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimEthnicity] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimEthnicity] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
