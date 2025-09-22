export const solarSystemData = {
  sun: {
    name: "Sun",
    type: "Star",
    description: "The Sun is the star at the center of our Solar System. It's a nearly perfect ball of hot plasma, heated to incandescence by nuclear fusion reactions in its core.",
    diameter: "1,391,400 km",
    mass: "1.989 × 10³⁰ kg",
    temperature: "5,778 K (surface), 15 million K (core)",
    age: "4.6 billion years",
    composition: "73% Hydrogen, 25% Helium, 2% Other elements",
    funFacts: [
      "The Sun contains 99.86% of the mass in our solar system",
      "Light from the Sun takes about 8 minutes and 20 seconds to reach Earth",
      "The Sun's core is so hot that if you placed a pinhead-sized piece of it on Earth, it would kill you from 150 km away",
      "Every second, the Sun converts 600 million tons of hydrogen into helium",
      "The Sun is so big that 1.3 million Earths could fit inside it"
    ],
    color: "#FDB813",
    size: 60,
    distance: 0,
    orbitalPeriod: "0 days"
  },
  
  mercury: {
    name: "Mercury",
    type: "Terrestrial Planet",
    description: "Mercury is the smallest planet in our solar system and the closest to the Sun. It has extreme temperature variations and no atmosphere.",
    diameter: "4,879 km",
    mass: "3.301 × 10²³ kg",
    temperature: "427°C (day), -173°C (night)",
    moons: 0,
    composition: "Large metallic core, thin silicate mantle",
    funFacts: [
      "A day on Mercury (243 Earth days) is longer than its year (88 Earth days)",
      "Mercury has the most eccentric orbit of all planets",
      "It has no atmosphere, so there's no weather",
      "Mercury is the second densest planet after Earth",
      "It has water ice at its poles despite being closest to the Sun"
    ],
    color: "#8C7853",
    size: 8,
    distance: 120,
    orbitalPeriod: "88 days"
  },
  
  venus: {
    name: "Venus",
    type: "Terrestrial Planet",
    description: "Venus is the second planet from the Sun and the hottest planet in our solar system due to its thick, toxic atmosphere.",
    diameter: "12,104 km",
    mass: "4.867 × 10²⁴ kg",
    temperature: "462°C (surface)",
    moons: 0,
    composition: "Rocky surface with thick CO₂ atmosphere",
    funFacts: [
      "Venus rotates backwards (retrograde rotation)",
      "It's the hottest planet, even hotter than Mercury",
      "A day on Venus is longer than its year",
      "Venus has more volcanoes than any other planet",
      "It rains sulfuric acid on Venus, but it evaporates before hitting the ground"
    ],
    color: "#FFC649",
    size: 12,
    distance: 160,
    orbitalPeriod: "225 days"
  },
  
  earth: {
    name: "Earth",
    type: "Terrestrial Planet",
    description: "Earth is the third planet from the Sun and the only known planet to harbor life. It has liquid water, a protective atmosphere, and a perfect distance from the Sun.",
    diameter: "12,756 km",
    mass: "5.972 × 10²⁴ kg",
    temperature: "15°C (average)",
    moons: 1,
    composition: "71% water surface, nitrogen-oxygen atmosphere",
    funFacts: [
      "Earth is the only known planet with life",
      "The Earth's core is as hot as the Sun's surface",
      "Earth has the strongest magnetic field of all rocky planets",
      "A year on Earth is getting longer by about 1.7 milliseconds per century",
      "Earth is the densest planet in the solar system"
    ],
    color: "#6B93D6",
    size: 12,
    distance: 200,
    orbitalPeriod: "365 days"
  },
  
  mars: {
    name: "Mars",
    type: "Terrestrial Planet",
    description: "Mars is the fourth planet from the Sun, known as the 'Red Planet' due to iron oxide on its surface. It has the largest volcano and canyon in the solar system.",
    diameter: "6,792 km",
    mass: "6.417 × 10²³ kg",
    temperature: "-65°C (average)",
    moons: 2,
    composition: "Iron oxide surface, thin CO₂ atmosphere",
    funFacts: [
      "Mars has the largest volcano in the solar system (Olympus Mons)",
      "A day on Mars is very similar to Earth (24 hours 37 minutes)",
      "Mars has seasons similar to Earth because of its axial tilt",
      "The red color comes from iron oxide (rust) on its surface",
      "Mars has polar ice caps made of water and carbon dioxide"
    ],
    color: "#CD5C5C",
    size: 10,
    distance: 250,
    orbitalPeriod: "687 days"
  },
  
  jupiter: {
    name: "Jupiter",
    type: "Gas Giant",
    description: "Jupiter is the largest planet in our solar system. It's a gas giant with a Great Red Spot storm and over 80 moons.",
    diameter: "142,984 km",
    mass: "1.898 × 10²⁷ kg",
    temperature: "-110°C (cloud tops)",
    moons: 95,
    composition: "Mostly hydrogen and helium",
    funFacts: [
      "Jupiter is larger than all other planets combined",
      "The Great Red Spot is a storm larger than Earth",
      "Jupiter acts as a 'cosmic vacuum cleaner' protecting inner planets",
      "It has the shortest day of all planets (9 hours 56 minutes)",
      "Jupiter has a faint ring system discovered in 1979"
    ],
    color: "#D8CA9D",
    size: 35,
    distance: 320,
    orbitalPeriod: "12 years"
  },
  
  saturn: {
    name: "Saturn",
    type: "Gas Giant",
    description: "Saturn is the second-largest planet and is famous for its prominent ring system. It's less dense than water and has over 80 moons.",
    diameter: "120,536 km",
    mass: "5.683 × 10²⁶ kg",
    temperature: "-140°C (cloud tops)",
    moons: 146,
    composition: "Mostly hydrogen and helium, prominent ring system",
    funFacts: [
      "Saturn is less dense than water and would float",
      "Its rings are made mostly of water ice and rock",
      "Saturn has hexagonal storms at its north pole",
      "Titan, Saturn's largest moon, has lakes of liquid methane",
      "Saturn's rings are only about 30 feet thick despite being 175,000 miles wide"
    ],
    color: "#FAD5A5",
    size: 30,
    distance: 380,
    orbitalPeriod: "29 years"
  },
  
  uranus: {
    name: "Uranus",
    type: "Ice Giant",
    description: "Uranus is an ice giant that rotates on its side. It has a unique blue-green color due to methane in its atmosphere and has faint rings.",
    diameter: "51,118 km",
    mass: "8.681 × 10²⁵ kg",
    temperature: "-195°C (cloud tops)",
    moons: 27,
    composition: "Water, methane, and ammonia ices",
    funFacts: [
      "Uranus rotates on its side (98-degree axial tilt)",
      "It was the first planet discovered with a telescope",
      "Uranus has the coldest planetary atmosphere in the solar system",
      "Its rings were discovered in 1977, almost 200 years after the planet",
      "A season on Uranus lasts 21 Earth years"
    ],
    color: "#4FD0E7",
    size: 20,
    distance: 450,
    orbitalPeriod: "84 years"
  },
  
  neptune: {
    name: "Neptune",
    type: "Ice Giant",
    description: "Neptune is the outermost planet in our solar system. It's a windy ice giant with the fastest winds in the solar system and a deep blue color.",
    diameter: "49,528 km",
    mass: "1.024 × 10²⁶ kg",
    temperature: "-200°C (cloud tops)",
    moons: 16,
    composition: "Water, methane, and ammonia ices",
    funFacts: [
      "Neptune has the fastest winds in the solar system (up to 2,100 km/h)",
      "It was the first planet discovered through mathematical prediction",
      "Neptune takes 165 Earth years to orbit the Sun",
      "It has a Great Dark Spot similar to Jupiter's Great Red Spot",
      "Neptune radiates 2.6 times more energy than it receives from the Sun"
    ],
    color: "#4B70DD",
    size: 20,
    distance: 520,
    orbitalPeriod: "165 years"
  }
};

export const getPlanetOrder = () => [
  'mercury', 'venus', 'earth', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune'
];