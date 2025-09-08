/*
 * Interactive Solar System Explorer with Zoom and Scroll capabilities
 * 
 * Features:
 * - Click on any planet or Sun to see detailed information
 * - Zoom in/out using:
 *   - Zoom buttons in the interface
 *   - Ctrl + Mouse Scroll
 *   - Keyboard shortcuts: + (zoom in), - (zoom out), 0 (reset)
 * - Scroll to navigate around the solar system when zoomed in
 * - Pause/Play orbital animations
 * - Responsive design for all screen sizes
 * 
 * Controls:
 * - ESC: Close popup
 * - +/-: Zoom in/out
 * - 0: Reset zoom to 100%
 * - Ctrl+Scroll: Zoom with mouse wheel
 */

import React, { useState, useRef, useEffect } from 'react';
import { solarSystemData, getPlanetOrder } from '../solarSystemData';
import PlanetPopup from './PlanetPopup';
import './SolarSystem.css';

const SolarSystem = () => {
  const [selectedPlanet, setSelectedPlanet] = useState(null);
  const [popupPosition, setPopupPosition] = useState({ x: 0, y: 0 });
  const [isAnimating, setIsAnimating] = useState(true);
  const [zoomLevel, setZoomLevel] = useState(1);
  const solarSystemRef = useRef(null);

  const minZoom = 0.3;
  const maxZoom = 2;
  const zoomStep = 0.2;

  const handleZoomIn = () => {
    setZoomLevel(prev => Math.min(prev + zoomStep, maxZoom));
  };

  const handleZoomOut = () => {
    setZoomLevel(prev => Math.max(prev - zoomStep, minZoom));
  };

  const handleResetZoom = () => {
    setZoomLevel(1);
  };

  const handleCelestialBodyClick = (key, event) => {
    const rect = event.currentTarget.getBoundingClientRect();
    const containerRect = solarSystemRef.current.getBoundingClientRect();
    
    // Calculate position relative to the viewport
    const x = rect.left + rect.width / 2;
    const y = rect.top - 20; // Position popup above the planet
    
    setPopupPosition({ x, y });
    setSelectedPlanet(solarSystemData[key]);
    
    // Brief pause in animation when clicking
    setIsAnimating(false);
    setTimeout(() => setIsAnimating(true), 1000);
  };

  const handleClosePopup = () => {
    setSelectedPlanet(null);
  };

  const handleBackgroundClick = (event) => {
    if (event.target === solarSystemRef.current) {
      handleClosePopup();
    }
  };

  useEffect(() => {
    const handleKeyPress = (event) => {
      if (event.key === 'Escape') {
        handleClosePopup();
      } else if (event.key === '+' || event.key === '=') {
        handleZoomIn();
      } else if (event.key === '-') {
        handleZoomOut();
      } else if (event.key === '0') {
        handleResetZoom();
      }
    };

    const handleWheel = (event) => {
      if (event.ctrlKey) {
        event.preventDefault();
        if (event.deltaY < 0) {
          handleZoomIn();
        } else {
          handleZoomOut();
        }
      }
    };

    document.addEventListener('keydown', handleKeyPress);
    document.addEventListener('wheel', handleWheel, { passive: false });
    
    return () => {
      document.removeEventListener('keydown', handleKeyPress);
      document.removeEventListener('wheel', handleWheel);
    };
  }, []);

  const renderOrbit = (distance) => (
    <div
      key={`orbit-${distance}`}
      className="orbit"
      style={{
        width: `${distance * 2}px`,
        height: `${distance * 2}px`,
      }}
    />
  );

  const renderCelestialBody = (key, data) => {
    const isMoving = isAnimating && key !== 'sun';
    
    return (
      <div
        key={key}
        className={`celestial-body ${key} ${isMoving ? 'rotating' : ''}`}
        style={{
          width: `${data.size}px`,
          height: `${data.size}px`,
          backgroundColor: data.color,
          left: key === 'sun' ? '50%' : `calc(50% + ${data.distance}px)`,
          top: '50%',
          transform: 'translate(-50%, -50%)',
          animationDuration: key !== 'sun' ? `${Math.sqrt(data.distance) * 2}s` : 'none',
        }}
        onClick={(e) => handleCelestialBodyClick(key, e)}
        title={`Click to learn about ${data.name}`}
      >
        <div className="celestial-glow" style={{ backgroundColor: data.color }} />
        <div className="celestial-name">{data.name}</div>
        {key === 'saturn' && <div className="saturn-rings" />}
      </div>
    );
  };

  return (
    <div className="solar-system-container">
      <div className="solar-system-header">
        <h1>🌌 Interactive Solar System Explorer</h1>
        <p>Click on any celestial body to discover fascinating details and fun facts!</p>
        <div className="controls">
          <button 
            className={`animation-toggle ${isAnimating ? 'active' : ''}`}
            onClick={() => setIsAnimating(!isAnimating)}
          >
            {isAnimating ? '⏸️ Pause' : '▶️ Play'} Animation
          </button>
          
          <div className="zoom-controls">
            <button 
              className="zoom-btn"
              onClick={handleZoomOut}
              disabled={zoomLevel <= minZoom}
              title="Zoom Out (- key or Ctrl+Scroll)"
            >
              −
            </button>
            <span className="zoom-level">{Math.round(zoomLevel * 100)}%</span>
            <button 
              className="zoom-btn"
              onClick={handleZoomIn}
              disabled={zoomLevel >= maxZoom}
              title="Zoom In (+ key or Ctrl+Scroll)"
            >
              +
            </button>
            <button 
              className="zoom-btn"
              onClick={handleResetZoom}
              title="Reset Zoom (0 key)"
              style={{ marginLeft: '10px' }}
            >
              ⌂
            </button>
          </div>
        </div>
        <p style={{ fontSize: '0.9rem', opacity: 0.8, marginTop: '10px' }}>
          💡 Use Ctrl+Scroll to zoom, or +/- keys. Press 0 to reset zoom.
        </p>
      </div>

      <div 
        className="solar-system"
        ref={solarSystemRef}
        onClick={handleBackgroundClick}
        style={{
          transform: `scale(${zoomLevel})`,
        }}
      >
        {/* Render orbits */}
        {getPlanetOrder().map(planetKey => 
          renderOrbit(solarSystemData[planetKey].distance)
        )}

        {/* Render Sun */}
        {renderCelestialBody('sun', solarSystemData.sun)}

        {/* Render Planets */}
        {getPlanetOrder().map(planetKey =>
          renderCelestialBody(planetKey, solarSystemData[planetKey])
        )}

        {/* Background stars */}
        <div className="stars">
          {[...Array(100)].map((_, i) => (
            <div
              key={i}
              className="star"
              style={{
                left: `${Math.random() * 100}%`,
                top: `${Math.random() * 100}%`,
                animationDelay: `${Math.random() * 3}s`,
              }}
            />
          ))}
        </div>
      </div>

      {/* Planet Information Popup */}
      {selectedPlanet && (
        <PlanetPopup
          celestialBody={selectedPlanet}
          position={popupPosition}
          onClose={handleClosePopup}
        />
      )}

      <div className="solar-system-footer">
        <p>🚀 Explore the wonders of our solar system! Each celestial body has its own unique story to tell.</p>
        <p style={{ fontSize: '0.85rem', opacity: 0.7, marginTop: '5px' }}>
          🔍 Navigation: Scroll to move around • Ctrl+Scroll to zoom • Click planets for details
        </p>
      </div>
    </div>
  );
};

export default SolarSystem;