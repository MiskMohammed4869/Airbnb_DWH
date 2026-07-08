/*=====================================================
    Project: Airbnb Data Warehouse
    Author : Misk Mohammed

    Description:
    This script creates the GOLD layer using a Star
    Schema for the Airbnb Data Warehouse.

    Steps:
    1. Create Schema
    2. Create Dimension Tables
    3. Populate Dimension Tables
    4. Create Fact Table
    5. Populate Fact Table
    6. Sample Analysis Queries
======================================================*/
CREATE SCHEMA GOLD;
GO
/*=====================================================
                CREATE DIMENSION TABLES
======================================================*/
CREATE TABLE GOLD.DimLocation(
	location_key INT IDENTITY (1,1) PRIMARY KEY,
	city NVARCHAR(50),
	lat DECIMAL(18,10),
	lng DECIMAL(18,10)
);
GO

CREATE TABLE GOLD.DimRoom(
	room_key INT IDENTITY (1,1) PRIMARY KEY,
	room_type NVARCHAR(50),
    room_private BIT,
    room_shared BIT,
    bedrooms INT,
    person_capacity INT
);
GO

CREATE TABLE GOLD.DimHost
(
    host_key INT IDENTITY(1,1) PRIMARY KEY,
    host_is_superhost BIT,
    multi BIT
);
GO

CREATE TABLE GOLD.DimDay
(
    day_key INT IDENTITY(1,1) PRIMARY KEY,
    day_type NVARCHAR(20)
);
GO
/*=====================================================
                LOAD DIMENSION TABLES
======================================================*/
INSERT INTO GOLD.DimLocation (city, lat, lng)
SELECT DISTINCT
    city,
    lat,
    lng
FROM dbo.airbnb;
GO

INSERT INTO GOLD.DimRoom
(room_type, room_private, room_shared, bedrooms, person_capacity)
SELECT DISTINCT
    room_type,
    room_private,
    room_shared,
    bedrooms,
    person_capacity
FROM dbo.airbnb;
GO

INSERT INTO GOLD.DimHost
(host_is_superhost, multi)
SELECT DISTINCT
    host_is_superhost,
    multi
FROM dbo.airbnb;
GO

INSERT INTO GOLD.DimDay
(day_type)
SELECT DISTINCT
    day_type
FROM dbo.airbnb;
GO
/*=====================================================
                CREATE FACT TABLE
======================================================*/
CREATE TABLE GOLD.FactListing
(
    listing_key INT IDENTITY(1,1) PRIMARY KEY,

    location_key INT,
    room_key INT,
    host_key INT,
    day_key INT,

    realSum DECIMAL(10,2),
    guest_satisfaction_overall INT,
    cleanliness_rating INT,
    dist DECIMAL(10,4),
    metro_dist DECIMAL(10,4),
    attr_index DECIMAL(10,4),
    attr_index_norm DECIMAL(10,4),
    rest_index DECIMAL(10,4),
    rest_index_norm DECIMAL(10,4),

    FOREIGN KEY (location_key) REFERENCES GOLD.DimLocation(location_key),
    FOREIGN KEY (room_key) REFERENCES GOLD.DimRoom(room_key),
    FOREIGN KEY (host_key) REFERENCES GOLD.DimHost(host_key),
    FOREIGN KEY (day_key) REFERENCES GOLD.DimDay(day_key)
);
GO
/*=====================================================
                LOAD FACT TABLE
======================================================*/
INSERT INTO GOLD.FactListing
(
    location_key,
    room_key,
    host_key,
    day_key,
    realSum,
    guest_satisfaction_overall,
    cleanliness_rating,
    dist,
    metro_dist,
    attr_index,
    attr_index_norm,
    rest_index,
    rest_index_norm
)
SELECT
    dl.location_key,
    dr.room_key,
    dh.host_key,
    dd.day_key,
    a.realSum,
    a.guest_satisfaction_overall,
    a.cleanliness_rating,
    a.dist,
    a.metro_dist,
    a.attr_index,
    a.attr_index_norm,
    a.rest_index,
    a.rest_index_norm
FROM dbo.airbnb a
JOIN GOLD.DimLocation dl
    ON a.city = dl.city
   AND a.lat = dl.lat
   AND a.lng = dl.lng
JOIN GOLD.DimRoom dr
    ON a.room_type = dr.room_type
   AND a.room_private = dr.room_private
   AND a.room_shared = dr.room_shared
   AND a.bedrooms = dr.bedrooms
   AND a.person_capacity = dr.person_capacity
JOIN GOLD.DimHost dh
    ON a.host_is_superhost = dh.host_is_superhost
   AND a.multi = dh.multi
JOIN GOLD.DimDay dd
    ON a.day_type = dd.day_type;
GO
/*=====================================================
                ANALYSIS QUERIES
======================================================*/
--------------------------------------------------------
-- 1. Average Price by City
--------------------------------------------------------
SELECT
    dl.city,
    AVG(f.realSum) AS AveragePrice
FROM GOLD.FactListing f
JOIN GOLD.DimLocation dl
    ON f.location_key = dl.location_key
GROUP BY dl.city
ORDER BY AveragePrice DESC;


--------------------------------------------------------
-- 2. Average Price by Room Type
--------------------------------------------------------
SELECT
    dr.room_type,
    AVG(f.realSum) AS AveragePrice
FROM GOLD.FactListing f
JOIN GOLD.DimRoom dr
    ON f.room_key = dr.room_key
GROUP BY dr.room_type
ORDER BY AveragePrice DESC;


--------------------------------------------------------
-- 3. Average Guest Satisfaction by Day Type
--------------------------------------------------------
SELECT
    dd.day_type,
    AVG(f.guest_satisfaction_overall) AS AverageGuestSatisfaction
FROM GOLD.FactListing f
JOIN GOLD.DimDay dd
    ON f.day_key = dd.day_key
GROUP BY dd.day_type;


--------------------------------------------------------
-- 4. Number of Listings by City
--------------------------------------------------------
SELECT
    dl.city,
    COUNT(*) AS TotalListings
FROM GOLD.FactListing f
JOIN GOLD.DimLocation dl
    ON f.location_key = dl.location_key
GROUP BY dl.city
ORDER BY TotalListings DESC;


--------------------------------------------------------
-- 5. Average Price for Superhost vs Non-Superhost
--------------------------------------------------------
SELECT
    CASE
        WHEN dh.host_is_superhost = 1 THEN 'Superhost'
        ELSE 'Non-Superhost'
    END AS HostType,
    AVG(f.realSum) AS AveragePrice
FROM GOLD.FactListing f
JOIN GOLD.DimHost dh
    ON f.host_key = dh.host_key
GROUP BY dh.host_is_superhost;


--------------------------------------------------------
-- 6. Average Price by Number of Bedrooms
--------------------------------------------------------
SELECT
    dr.bedrooms,
    AVG(f.realSum) AS AveragePrice
FROM GOLD.FactListing f
JOIN GOLD.DimRoom dr
    ON f.room_key = dr.room_key
GROUP BY dr.bedrooms
ORDER BY dr.bedrooms;


--------------------------------------------------------
-- 7. Top 10 Most Expensive Cities
--------------------------------------------------------
SELECT TOP 10
    dl.city,
    AVG(f.realSum) AS AveragePrice
FROM GOLD.FactListing f
JOIN GOLD.DimLocation dl
    ON f.location_key = dl.location_key
GROUP BY dl.city
ORDER BY AveragePrice DESC;

