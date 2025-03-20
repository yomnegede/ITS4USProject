-- Install and load the DuckDB Spatial extension for geospatial queries
INSTALL spatial; 
LOAD spatial; -- noqa to ignore linting warnings for this line

-- Install and load the HTTPFS extension to access data stored in AWS S3 buckets
INSTALL httpfs;
LOAD httpfs;

-- Set the AWS S3 region for accessing spatial datasets
SET s3_region='us-west-2';

-- Extract ITS4US Places data within a specific bounding box and export to GeoJSON format
COPY(
    SELECT
       id,                                -- Unique identifier for each place
       names.primary AS name,            -- Primary name of the place
       confidence,                       -- Confidence score for the place
       CAST(socials AS JSON) AS socials, -- Social media links or additional information
       geometry                          -- Geospatial geometry of the place
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=places/type=place/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -84.222916 AND -83.973153 -- Longitude range
      AND bbox.ymin BETWEEN 33.874984 AND 33.989484   -- Latitude range
) TO 'its4us_places.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- Extract ITS4US Addresses data within a specific bounding box and export to GeoJSON format
COPY(
    SELECT
       id,                                    -- Unique identifier for each address
       CONCAT(number, ' ', street) AS address, -- Full address (number and street)
       postcode,                              -- Postal code
       geometry                               -- Geospatial geometry of the address
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=addresses/type=*/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -84 AND -82       -- Longitude range
      AND bbox.ymin BETWEEN 33 AND 35         -- Latitude range
) TO 'its4us_addresses.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- Extract ITS4US Buildings data within a specific bounding box and export to GeoJSON format
COPY(
    SELECT
       id,                                    -- Unique identifier for each building
       names.primary AS primary_name,         -- Primary name of the building
       height,                                -- Height of the building
       geometry                               -- Geospatial geometry of the building
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=buildings/type=building/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -84.222916 AND -83.973153 -- Longitude range
      AND bbox.ymin BETWEEN 33.874984 AND 33.989484   -- Latitude range
) TO 'its4us_buildings.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- Extract Places data for Downtown Atlanta and export to GeoJSON format
COPY(
    SELECT
       id,                                -- Unique identifier for each place
       names.primary AS name,            -- Primary name of the place
       confidence,                       -- Confidence score for the place
       CAST(socials AS JSON) AS socials, -- Social media links or additional information
       geometry                          -- Geospatial geometry of the place
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=places/type=place/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -84.4043 AND -84.3868 -- Longitude range for Downtown Atlanta
      AND bbox.ymin BETWEEN 33.7405 AND 33.7666   -- Latitude range for Downtown Atlanta
) TO 'downtown_places.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- Extract Addresses data for Downtown Atlanta and export to GeoJSON format
COPY(
    SELECT
       id,                                    -- Unique identifier for each address
       CONCAT(number, ' ', street) AS address, -- Full address (number and street)
       postcode,                              -- Postal code
       geometry                               -- Geospatial geometry of the address
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=addresses/type=*/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -85 AND -83       -- Longitude range for Downtown Atlanta
      AND bbox.ymin BETWEEN 33 AND 35         -- Latitude range for Downtown Atlanta
) TO 'downtown_addresses.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- Extract Buildings data for Downtown Atlanta and export to GeoJSON format
COPY(
    SELECT
       id,                                    -- Unique identifier for each building
       names.primary AS primary_name,         -- Primary name of the building
       height,                                -- Height of the building
       geometry                               -- Geospatial geometry of the building
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-12-18.0/theme=buildings/type=building/*', filename=true, hive_partitioning=1)
    WHERE bbox.xmin BETWEEN -84.4043 AND -84.3868 -- Longitude range for Downtown Atlanta
      AND bbox.ymin BETWEEN 33.7405 AND 33.7666   -- Latitude range for Downtown Atlanta
) TO 'downtown_buildings.geojson' WITH (FORMAT GDAL, DRIVER 'GeoJSON');