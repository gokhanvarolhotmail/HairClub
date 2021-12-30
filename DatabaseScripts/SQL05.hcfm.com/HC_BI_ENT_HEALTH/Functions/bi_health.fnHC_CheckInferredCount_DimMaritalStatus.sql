/* CreateDate: 05/12/2010 11:30:34.430 , ModifyDate: 05/13/2010 14:49:44.510 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimMaritalStatus] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimMaritalStatus]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimMaritalStatus]()
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

 	SET @TableName = N'[bi_cms_dds].[DimMaritalStatus]'


	INSERT INTO @tbl
		SELECT @TableName, MaritalStatusKey, CAST(MaritalStatusSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimMaritalStatus] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimMaritalStatus] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
