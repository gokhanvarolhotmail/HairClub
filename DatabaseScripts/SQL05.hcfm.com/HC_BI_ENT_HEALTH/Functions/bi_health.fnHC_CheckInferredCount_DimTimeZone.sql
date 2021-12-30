/* CreateDate: 05/12/2010 11:31:40.237 , ModifyDate: 05/13/2010 14:55:26.247 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimTimeZone] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimTimeZone]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimTimeZone]()
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

 	SET @TableName = N'[bi_cms_dds].[DimTimeZone]'


	INSERT INTO @tbl
		SELECT @TableName, TimeZoneKey, CAST(TimeZoneSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimTimeZone] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimTimeZone] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
