# ITS4US Project

A React + MapLibre web app for exploring the ITS4US and Downtown Atlanta geographic areas with layered map data, building footprints, and place/address information.

## Overview

This project visualizes a map of Atlanta using MapLibre GL and includes a toggle between two study areas:

- Downtown Atlanta
- ITS4US area

The app overlays geospatial datasets and shading to highlight the regions of interest, while rendering 3D building extrusion for a more immersive city view.

## Features

- Interactive map with MapLibre GL
- Toggle between Downtown Atlanta and ITS4US coverage areas
- Shaded region overlays for the selected study area
- 3D building extrusion at higher zoom levels
- Data extraction scripts for geospatial datasets from Overture Maps
- PMTiles-based map data assets for places, addresses, and buildings

## Tech Stack

- React
- MapLibre GL JS
- PMTiles
- DuckDB with Spatial and HTTPFS extensions
- Python for data extraction automation
- GeoJSON and Overture Maps datasets

## Repository Structure

```text
ITS4USProject/
├── QueryData.sql              # DuckDB queries to extract GeoJSON data from Overture Maps
├── RunQueryData.py            # Python script to run QueryData.sql
├── downtown_addresses.geojson # Sample Downtown Atlanta address data
├── downtown_buildings.geojson # Sample Downtown Atlanta building data
├── downtown_places.geojson    # Sample Downtown Atlanta place data
├── its4us_places.geojson      # ITS4US area place data
├── package.json               # React app dependencies and scripts
├── package-lock.json          # Lockfile for NPM dependencies
├── public/                    # Static app assets
├── src/                       # React app source code
│   ├── App.js                 # App entry component
│   ├── App.css                # App styles
│   ├── components/
│   │   ├── map.js             # Map rendering and interaction logic
│   │   ├── map.css            # Map-specific styling
│   │   ├── navbar.js          # Navbar component
│   │   ├── navbar.css         # Navbar styles
│   │   ├── places.pmtiles     # PMTiles place data
│   │   ├── addresses.pmtiles  # PMTiles address data
│   │   └── buildings.pmtiles  # PMTiles building data
│   ├── index.js               # React root render
│   ├── index.css              # Global styles
│   └── ...
└── README.md
```

## Getting Started

### Prerequisites

- Node.js 18+ recommended
- npm
- Python 3
- DuckDB installed for the data extraction workflow

### Install dependencies

```bash
npm install
```

### Start the app locally

```bash
npm start
```

This will start the development server for the React app.

## Data Workflow

The project includes a SQL workflow for extracting geospatial features from Overture Maps data stored in AWS S3. The script files are:

- `QueryData.sql`
- `RunQueryData.py`

These scripts pull place, address, and building data for Atlanta bounding boxes and export the result as GeoJSON files.

### Example data extraction

```bash
python RunQueryData.py
```

This reads the SQL statements in `QueryData.sql` and executes them with DuckDB.

## Map Configuration

The app uses MapTiler as the map base layer and includes a toggle that flies the map between:

- Downtown Atlanta: `(-84.3880, 33.7490)`
- ITS4US Area: `(-84.135, 33.911)`

The map also adds shaded polygon overlays and extruded building layers to provide a stronger geospatial context.

## Notes

- The project is a front-end visualization and data exploration prototype.
- If you plan to reload or regenerate map datasets, ensure the required AWS S3 access and DuckDB extensions are available.
- The app currently includes a MapTiler API key in `src/components/map.js`; if that key is restricted or expires, replace it with your own valid key.

## Future Improvements

- Add richer UI controls for filtering map layers
- Incorporate additional transportation and accessibility datasets
- Improve data caching and performance for larger geospatial layers
- Add deployment configuration for production hosting

## License

This project does not currently include a license file. If you plan to share or publish it publicly, consider adding an open-source license such as MIT.

## Contributing

Contributions are welcome. If you would like to improve the project:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Open a pull request

## Contact

For questions or collaboration opportunities, contact the repository owner via GitHub.
