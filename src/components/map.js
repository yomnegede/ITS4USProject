import React, { useRef, useEffect, useState } from 'react';
import maplibregl from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';
import './map.css';

export default function Map() {
  const mapContainer = useRef(null);
  const map = useRef(null);
  const [isIts4us, setIsIts4us] = useState(true); // State to toggle between areas

  const lng = -84.3880; // Downtown Atlanta Center
  const lat = 33.7490;
  const zoom = 14;
  const API_KEY = 'sF7hLLkuy1d3qtfO6loc';

  const locations = {
    downtown: { lng: -84.3880, lat: 33.7490, zoom: 14 },
    its4us: { lng: -84.135, lat: 33.911, zoom: 14 }
  };

  useEffect(() => {
    if (map.current) return;

    map.current = new maplibregl.Map({
      container: mapContainer.current,
      style: `https://api.maptiler.com/maps/streets-v2/style.json?key=${API_KEY}`,
      center: [lng, lat],
      zoom: zoom,
    });

    map.current.on('load', () => {
      // Define the world bounds (outer polygon)
      const worldBounds = [
        [-180, -90],
        [-180, 90],
        [180, 90],
        [180, -90],
        [-180, -90]
      ];

      // Define the Downtown Atlanta area (hole 1)
      const atlantaBounds = [
        [-84.4, 33.74], // Bottom-left
        [-84.4, 33.76], // Top-left
        [-84.37, 33.76], // Top-right
        [-84.37, 33.74], // Bottom-right
        [-84.4, 33.74]   // Close the loop
      ];

      // Define the ITS4US area (hole 2)
      const its4usBounds = [
        [-84.295394, 33.856720], // Bottom-left
        [-84.295394, 33.966701], // Top-left
        [-83.973897, 33.966701], // Top-right
        [-83.973897, 33.856720], // Bottom-right
        [-84.295394, 33.856720]  // Close the loop
      ];

      // Create an inverse polygon combining the world bounds with the two holes
      const shadedArea = {
        type: 'FeatureCollection',
        features: [
          {
            type: 'Feature',
            geometry: {
              type: 'Polygon',
              coordinates: [
                worldBounds, // Outer polygon (world)
                atlantaBounds, // Downtown Atlanta (hole)
                its4usBounds  // ITS4US area (hole)
              ]
            }
          }
        ]
      };

      // Add the shaded area as a source
      map.current.addSource('shaded-area', {
        type: 'geojson',
        data: shadedArea
      });

      // Add a fill layer with gradient shading
      map.current.addLayer({
        id: 'shaded-area-layer',
        type: 'fill',
        source: 'shaded-area',
        paint: {
          'fill-color': [
            'interpolate',
            ['linear'],
            ['zoom'],
            0, 'rgba(173, 216, 230, 0.5)', // Light blue at far zoom
            10, 'rgba(70, 130, 180, 0.7)', // Steel blue at closer zoom
          ],
          'fill-opacity': 0.6, // Consistent opacity for clarity
        }
      });

      // Add a blurred border around the shaded area
      map.current.addLayer({
        id: 'shaded-area-border',
        type: 'line',
        source: 'shaded-area',
        paint: {
          'line-color': 'rgba(70, 130, 180, 0.7)',
          'line-width': 4,
          'line-blur': 2, // Soft blur for the border
        }
      });

      // Add 3D buildings
      map.current.addLayer({
        id: '3d-buildings',
        source: 'openmaptiles',
        'source-layer': 'building',
        type: 'fill-extrusion',
        minzoom: 15, // Only show buildings at zoom level 15 or higher
        paint: {
          'fill-extrusion-color': '#aaa', // Building color
          'fill-extrusion-height': [
            'interpolate',
            ['linear'],
            ['zoom'],
            15, 0,
            16, ['get', 'height'] // Use building height property
          ],
          'fill-extrusion-base': [
            'interpolate',
            ['linear'],
            ['zoom'],
            15, 0,
            16, ['get', 'min_height'] // Use min_height property if available
          ],
          'fill-extrusion-opacity': 0.8
        }
      });
    });
  }, [API_KEY, lng, lat, zoom]);

  const handleButtonClick = () => {
    const target = isIts4us
      ? { ...locations.its4us, zoom: 16 } // Increase zoom for ITS4US Area
      : { ...locations.downtown, zoom: 14 }; // Default zoom for Downtown Atlanta
  
    map.current.flyTo({
      center: [target.lng, target.lat],
      zoom: target.zoom,
      essential: true // Smooth animation
    });
  
    setIsIts4us(!isIts4us); // Toggle the state
  };
  

  return (
    <div className="map-wrap">
      <button className="toggle-button" onClick={handleButtonClick}>
        {isIts4us ? 'Go to ITS4US Area!' : 'Go to Downtown Atlanta Area!'}
      </button>
      <div ref={mapContainer} className="map" />
    </div>
  );
}
