/* CreateDate: 10/25/2011 08:41:44.313 , ModifyDate: 10/25/2011 08:41:44.313 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemVendorContract] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemVendorContract]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemVendorContract]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemVendorContract]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemVendorContractKey, CAST(HairSystemVendorContractSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemVendorContract] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
