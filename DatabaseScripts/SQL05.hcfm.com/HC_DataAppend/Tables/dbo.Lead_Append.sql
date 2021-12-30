/* CreateDate: 03/09/2017 13:55:12.020 , ModifyDate: 06/02/2017 20:07:29.047 */
GO
CREATE TABLE [dbo].[Lead_Append](
	[LeadAppendID] [int] IDENTITY(1,1) NOT NULL,
	[CVMacroRecID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city_standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[standardized] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CVMacroMatchGroup] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CVMacroMatchLevel] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IndividualZeroBasedID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CVMacroFuzzyMatchOverallScore] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_AddressPlusSuite] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_City] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_Results] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_State] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_Suite] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CASS_ZIP] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PERSON ID NUMBER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PERSON TYPE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FULLNAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIRST NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MIDDLE INITIAL V2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SURNAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NAME SUFFIX] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NAME PREFIX] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GENDER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COMBINED AGE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDUCATION MODEL] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MARITAL STATUS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OCCUPATION GROUP V2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Household Person Number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIRST NAME LAST NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HH_ZeroBasedRecordID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADDRESS ID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIPS STATE CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STATE ABBREVIATION] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIPS ZIP CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP_4] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DELIVERY POINT CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CARRIER ROUTE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SHORT CITY NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CITY NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOUSE NUMBER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PRE DIRECTION] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STREET NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STREET SUFFIX] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[POST DIRECTION] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UNIT DESIGNATOR] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UNIT DESIGNATOR NUMBER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PRIMARY ADDRESS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SECONDARY ADDRESS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIPS COUNTY CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COUNTY NAME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LATITUDE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LONGITUDE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MATCH LEVEL FOR GEO DATA] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TIME ZONE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LIVING UNIT ID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONE_SPECIAL USAGE PHONE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONE_NUMBER 2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWELLING UNIT SIZE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWELLING TYPE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOMEOWNER_ COMBINED HOMEOWNER_RENTER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EST HOUSEHOLD INCOME V5] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NCOA MOVE UPDATE CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NCOA MOVE UPDATE DATE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MAIL RESPONDER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LENGTH OF RESIDENCE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NUMBER OF PERSONS IN LIVING UNIT] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NUMBER OF ADULTS IN LIVING UNIT] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RURAL URBAN COUNTY SIZE CODE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACTIVITY DATE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ UPSCALE MERCHANDISE BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ MALE MERCHANDISE BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ FEMALE MERCHANDISE BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ CRAFTS_HOBBY MERCHANDISE BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ GARDENING_FARMING BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ BOOK BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ COLLECT_SPECIAL FOODS BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ GIFTS AND GADGETS BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ GENERAL MERCHANDISE BUYER] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ FAMILY AND GENERAL MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ FEMALE ORIENTED MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ MALE SPORTS MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ RELIGIOUS MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ GARDENING_FARMING MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ CULINARY INTERESTS MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ HEALTH AND FITNESS MAGAZINE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ DO_IT_YOURSELFERS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ NEWS AND FINANCIAL] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ PHOTOGRAPHY] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ OPPORTUNITY SEEKERS AND CE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ RELIGIOUS CONTRIBUTOR] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ POLITICAL CONTRIBUTOR] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ HEALTH AND INSTITUTION CONTRIBUTOR] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ GENERAL CONTRIBUTOR] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ MISCELLANEOUS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ ODDS AND ENDS] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ DEDUPED CATEGORY HIT COUNT] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR BANK_ NON_DEDUPED CATEGORY HIT COUNT] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MORTGAGE_HOME PURCHASE_ HOME PURCHASE PRICE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MORTGAGE_HOME PURCHASE_ HOME PURCHASE DATE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PROPERTY_REALTY_ HOME YEAR BUILT] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOSAIC HOUSEHOLD] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOSAIC ZIP4] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOUSEHOLD COMPOSITION] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CORE BASED STATISTICAL AREAS _CBSA_] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CORE BASED STATISTICAL AREA TYPE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CHILDREN_ AGE 0_18 VERSION 3] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHONE_ACTIVITY DATE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CENSUS 2010_ TRACT AND BLOCK GROUP] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ AGE_ POP_ MEDIAN AGE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ AGE_ POP_ _ 0_17] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ AGE_ POP_ _ 18_99_] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ AGE_ POP_ _ 65_99_] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ ETHNIC_ POP_ _ WHITE ONLY] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ ETHNIC_ POP_ _ BLACK ONLY] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ ETHNIC_ POP_ _ ASIAN ONLY] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ ETHNIC_ POP_ _ HISPANIC] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ DENSITY_ PERSONS PER HH FOR POP IN HH] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ HHSIZE_ HH_ AVERAGE HOUSEHOLD SIZE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ TYP_ HH_ _ MARRIED COUPLE FAMILY] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ CHILD_ HH_ _ WITH PERSONS LT18] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ CHILD_ HH_ _ MARR COUPLE FAMW_ PERSONS LT18] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ CHILD_ HH_ _ MARR COUPLE FAMW_O PERSONS LT18] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ LANG_ HH_ _ SPANISH SPEAKING] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ EDUC_ POP25__ MEDIAN EDUCATION ATTAINED] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ HOMVAL_ OOHU_ MEDIAN HOME VALUE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ HUSTR_ HU_ _ MOBILE HOME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ BUILT_ HU_ MEDIAN HOUSING UNIT AGE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ TENANCY_ OCCHU_ _ OWNER OCCUPIED] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ TENANCY_ OCCHU_ _ RENTER OCCUPIED] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ EDUC_ ISPSA] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ EDUC_ ISPSA DECILE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ INC_ FAMILY INC STATE DECILE] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_ INC_ HH_ MEDIAN FAMILY HOUSEHOLD INCOME] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MatchStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Score] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lat] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lon] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GeoLevel] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CensusId] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressPlusSuite] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Country_Origin_Code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Ethnicity_Code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Ethnic_Group_Code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Religion_Code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Spoken_Language_Code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_Lead_Append] PRIMARY KEY CLUSTERED
(
	[LeadAppendID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_Append_contact_id] ON [dbo].[Lead_Append]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lead_Append_CreateDate_INCL] ON [dbo].[Lead_Append]
(
	[CreateDate] ASC
)
INCLUDE([LastUpdate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lead_Append_LastUpdate_INCL] ON [dbo].[Lead_Append]
(
	[LastUpdate] ASC
)
INCLUDE([CreateDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lead_Append] ADD  CONSTRAINT [DF_Lead_Append_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Lead_Append] ADD  CONSTRAINT [DF_Lead_Append_CreateUser]  DEFAULT (N'DLeiba') FOR [CreateUser]
GO
ALTER TABLE [dbo].[Lead_Append] ADD  CONSTRAINT [DF_Lead_Append_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[Lead_Append] ADD  CONSTRAINT [DF_Lead_Append_LastUpdateUser]  DEFAULT (N'DLeiba') FOR [LastUpdateUser]
GO
