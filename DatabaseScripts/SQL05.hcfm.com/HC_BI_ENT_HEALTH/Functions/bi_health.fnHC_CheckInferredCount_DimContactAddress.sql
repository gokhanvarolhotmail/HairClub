/* CreateDate: 05/12/2010 10:57:34.337 , ModifyDate: 05/13/2010 14:45:32.543 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimContactAddress] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimContactAddress]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimContactAddress]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactAddress]'


	INSERT INTO @tbl
		SELECT @TableName, ContactAddressKey, ContactAddressSSID
		FROM [bi_health].[synHC_DDS_DimContactAddress] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimContactAddress] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
