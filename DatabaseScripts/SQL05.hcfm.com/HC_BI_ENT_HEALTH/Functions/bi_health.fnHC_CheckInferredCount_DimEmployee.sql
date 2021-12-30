/* CreateDate: 05/12/2010 11:12:43.773 , ModifyDate: 05/13/2010 14:47:14.783 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimEmployee]()
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'


	INSERT INTO @tbl
		SELECT @TableName, EmployeeKey, CAST(EmployeeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimEmployee] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimEmployee] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
