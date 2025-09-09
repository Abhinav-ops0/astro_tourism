# 🌌 Astro Tourism - Interactive Solar System Explorer

An immersive web application for exploring our solar system with detailed information about each celestial body. Perfect for space enthusiasts, educators, and students looking to learn about space in an engaging way.

## ✨ Features

### 🪐 Interactive Solar System
- **Realistic Visualization**: Beautifully rendered solar system with accurate relative sizes and orbital positions
- **Clickable Celestial Bodies**: Click on any planet or the Sun to discover fascinating details
- **Animated Orbits**: Watch planets orbit around the Sun with realistic timing
- **Detailed Information**: Comprehensive data including diameter, mass, temperature, composition, and orbital periods
- **Fun Facts**: Engaging and educational facts about each celestial body
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices

### 🎛️ Interactive Controls
- **Animation Toggle**: Pause/play orbital animations
- **Popup Information**: Rich, detailed popups with scientific data and fun facts
- **Keyboard Support**: Press 'Escape' to close popups
- **Hover Effects**: Visual feedback when hovering over planets

### 🎨 Visual Excellence
- **Stunning Graphics**: Gradient backgrounds, glowing effects, and realistic planet textures
- **Space Atmosphere**: Twinkling stars and deep space background
- **Smooth Animations**: Fluid orbital movements and transitions
- **Accessibility**: High contrast and readable text for all users

## 📱 Project Structure

```
astro_tourism/
├── backend/                    # Python Flask backend (optional)
│   ├── venv/                  # Python virtual environment
│   ├── app.py                 # Flask application
│   └── requirements.txt       # Python dependencies
└── frontend/                   # React.js frontend
    ├── src/
    │   ├── components/         # React components
    │   │   ├── SolarSystem.jsx   # Main solar system component
    │   │   ├── SolarSystem.css   # Solar system styling
    │   │   ├── PlanetPopup.jsx   # Popup component for planet details
    │   │   └── PlanetPopup.css   # Popup styling
    │   ├── solarSystemData.js    # Planet data and information
    │   ├── App.jsx              # Main App component
    │   └── App.css              # App styling
    └── package.json             # Node.js dependencies
```

## 🚀 Getting Started

### Quick Start (Frontend Only)

The solar system explorer works as a standalone frontend application!

1. **Clone and navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start the development server:**
   ```bash
   npm run dev
   ```

4. **Open your browser and visit:**
   ```
   http://localhost:5173
   ```

🎉 **That's it!** Start exploring the solar system by clicking on any planet or the Sun!

### 🌐 Production Deployment on AWS EC2

For production deployment with Docker and Nginx on Amazon EC2:

1. **Set up EC2 instance:**
   ```bash
   # Run on your EC2 instance
   sudo ./scripts/setup-ec2.sh
   ```

2. **Deploy the application:**
   ```bash
   # Clone repository and deploy
   git clone <your-repo-url>
   cd astro_tourism
   make deploy
   ```

3. **Access your application:**
   ```
   http://your-ec2-public-ip
   ```

📖 **Detailed deployment guide:** See [DEPLOYMENT.md](DEPLOYMENT.md) for comprehensive AWS EC2 deployment instructions.

### 🛠️ Development Commands

Use the included Makefile for easy development:

```bash
make help          # Show all available commands
make dev-frontend  # Start frontend development
make dev-backend   # Start backend development
make build         # Build Docker images
make deploy        # Deploy to production
make logs          # View application logs
make health        # Check application health
```

### 🔍 How to Use

1. **Explore**: Click on any celestial body (Sun, planets) to learn about it
2. **Read**: Detailed popups show scientific data, composition, and fun facts
3. **Control**: Use the pause/play button to control orbital animations
4. **Navigate**: Press 'Escape' to close popups, click background to deselect
5. **Discover**: Each planet has unique information and interesting facts!

### 🎯 What You'll Learn

- **Planetary Data**: Size, mass, temperature, and composition of each planet
- **Orbital Mechanics**: How planets move around the Sun
- **Space Facts**: Amazing and educational facts about our solar system
- **Scientific Information**: Real astronomical data presented in an accessible way

## 🛠️ Technologies Used

### Frontend
- **React 18** - Modern JavaScript library for building user interfaces
- **Vite** - Fast build tool and development server
- **CSS3** - Advanced styling with animations, gradients, and transforms
- **JavaScript ES6+** - Modern JavaScript features and syntax

### Backend
- **Python 3.11** - Programming language
- **Flask 3.0.0** - Lightweight web framework
- **Flask-CORS 4.0.0** - Cross-Origin Resource Sharing support
- **Gunicorn** - Python WSGI HTTP Server for production

### DevOps & Deployment
- **Docker** - Containerization platform
- **Docker Compose** - Multi-container orchestration
- **Nginx** - High-performance web server and reverse proxy
- **Amazon EC2** - Cloud hosting platform
- **Ubuntu 22.04 LTS** - Operating system

## 🎨 Key Features Implemented

### 🪐 Interactive Elements
- Clickable planets and Sun with hover effects
- Detailed information popups with scientific data
- Animation controls (pause/play orbital motion)
- Responsive design for all screen sizes

### 📊 Educational Content
- Comprehensive data for all 8 planets plus the Sun
- Fun facts and interesting trivia
- Scientific accuracy in planetary information
- Easy-to-understand presentation of complex data

### 🎆 Visual Effects
- Realistic planet colors and textures
- Glowing effects and animations
- Saturn's ring system visualization
- Twinkling stars background
- Smooth orbital animations

## 🔧 Development

The application uses **Vite's Hot Module Replacement (HMR)** for instant updates during development. Simply save your changes and see them reflected immediately in the browser!

### 📁 File Structure Highlights

- **`solarSystemData.js`** - Contains all planetary data, facts, and configuration
- **`SolarSystem.jsx`** - Main component with orbital visualization and interactions
- **`PlanetPopup.jsx`** - Detailed information popup component
- **CSS files** - Comprehensive styling with animations and responsive design

## 🌍 Educational Value

This application serves as an excellent educational tool for:
- **Students** learning about astronomy and space science
- **Educators** teaching about our solar system
- **Space enthusiasts** exploring planetary data
- **Anyone curious** about the wonders of space

---

**🌠 Start your cosmic journey today! Click on any planet to begin exploring!** 🚀
A way  to explore space and know more about vastness of universe
