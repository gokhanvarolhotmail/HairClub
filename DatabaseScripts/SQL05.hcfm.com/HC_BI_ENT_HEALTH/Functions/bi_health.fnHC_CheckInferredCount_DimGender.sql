/* CreateDate: 05/12/2010 11:29:13.900 , ModifyDate: 05/13/2010 14:48:21.203 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimGender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimGender]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimGender]()
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

 	SET @TableName = N'[bi_cms_dds].[DimGender]'


	INSERT INTO @tbl
		SELECT @TableName, GenderKey, CAST(GenderSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimGender] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimGender] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
