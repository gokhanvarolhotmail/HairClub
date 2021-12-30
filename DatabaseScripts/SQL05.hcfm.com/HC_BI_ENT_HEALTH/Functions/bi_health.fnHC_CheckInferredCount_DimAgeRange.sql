/* CreateDate: 05/12/2010 11:25:37.887 , ModifyDate: 05/13/2010 14:41:17.013 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimAgeRange] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimAgeRange]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAgeRange]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAgeRange]'


	INSERT INTO @tbl
		SELECT @TableName, AgeRangeKey, CAST(AgeRangeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimAgeRange] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimAgeRange] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
