/****** Object:  ExternalFileFormat [QuotedCsvWithHeader]    Script Date: 1/7/2022 4:05:02 PM ******/
CREATE EXTERNAL FILE FORMAT [QuotedCsvWithHeader] WITH (FORMAT_TYPE = DELIMITEDTEXT, FORMAT_OPTIONS (FIELD_TERMINATOR = N',', STRING_DELIMITER = N'"', FIRST_ROW = 2, USE_TYPE_DEFAULT = True))
GO
