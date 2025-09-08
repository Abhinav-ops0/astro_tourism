import React from 'react';
import './PlanetPopup.css';

const PlanetPopup = ({ celestialBody, position, onClose }) => {
  if (!celestialBody) return null;

  const { name, type, description, diameter, mass, temperature, moons, composition, funFacts, orbitalPeriod } = celestialBody;

  return (
    <div 
      className="planet-popup"
      style={{
        left: position.x,
        top: position.y,
      }}
    >
      <div className="popup-header">
        <h2>{name}</h2>
        <button className="close-btn" onClick={onClose}>×</button>
      </div>
      
      <div className="popup-content">
        <div className="celestial-type">{type}</div>
        
        <div className="description">
          <p>{description}</p>
        </div>
        
        <div className="details-grid">
          <div className="detail-item">
            <span className="label">Diameter:</span>
            <span className="value">{diameter}</span>
          </div>
          
          <div className="detail-item">
            <span className="label">Mass:</span>
            <span className="value">{mass}</span>
          </div>
          
          <div className="detail-item">
            <span className="label">Temperature:</span>
            <span className="value">{temperature}</span>
          </div>
          
          {moons !== undefined && (
            <div className="detail-item">
              <span className="label">Moons:</span>
              <span className="value">{moons}</span>
            </div>
          )}
          
          <div className="detail-item">
            <span className="label">Orbital Period:</span>
            <span className="value">{orbitalPeriod}</span>
          </div>
          
          <div className="detail-item composition">
            <span className="label">Composition:</span>
            <span className="value">{composition}</span>
          </div>
        </div>
        
        <div className="fun-facts">
          <h3>🌟 Fun Facts</h3>
          <ul>
            {funFacts.map((fact, index) => (
              <li key={index}>{fact}</li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default PlanetPopup;