const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());

app.get("/api/prices", (req, res) => {
  const crop = req.query.crop || "Wheat";

  const mandiData = [
    // 🌾 WHEAT
    {
      market: "Azadpur Mandi (Delhi)",
      crop: "Wheat",
      min_price: 2100,
      max_price: 2400,
      modal_price: 2300,
    },
    {
      market: "Noida Mandi",
      crop: "Wheat",
      min_price: 2200,
      max_price: 2500,
      modal_price: 2350,
    },
    {
      market: "Ghaziabad Mandi",
      crop: "Wheat",
      min_price: 2150,
      max_price: 2450,
      modal_price: 2320,
    },

    // 🌾 RICE
    {
      market: "Karnal Mandi",
      crop: "Rice",
      min_price: 1800,
      max_price: 2200,
      modal_price: 2050,
    },
    {
      market: "Panipat Mandi",
      crop: "Rice",
      min_price: 1750,
      max_price: 2150,
      modal_price: 2000,
    },

    // 🥔 POTATO
    {
      market: "Agra Mandi",
      crop: "Potato",
      min_price: 900,
      max_price: 1400,
      modal_price: 1200,
    },
    {
      market: "Kanpur Mandi",
      crop: "Potato",
      min_price: 1000,
      max_price: 1500,
      modal_price: 1300,
    },

    // 🍅 TOMATO
    {
      market: "Azadpur Mandi (Delhi)",
      crop: "Tomato",
      min_price: 800,
      max_price: 1600,
      modal_price: 1200,
    },
    {
      market: "Lucknow Mandi",
      crop: "Tomato",
      min_price: 900,
      max_price: 1700,
      modal_price: 1350,
    },
  ];

  // 🔥 filter by crop
  const filtered = mandiData.filter(
    (item) => item.crop.toLowerCase() === crop.toLowerCase()
  );

  res.json(filtered);
});

// ✅ MUST BE OUTSIDE
app.listen(5000, () => {
  console.log("Server running on port 5000");
});

const fs = require("fs");

app.get("/api/schemes", (req, res) => {
  try {
    const data = fs.readFileSync("schemes.json");
    const schemes = JSON.parse(data);

    res.json(schemes);
  } catch (err) {
    console.error("SCHEME ERROR:", err);
    res.status(500).json({ error: "Failed to load schemes" });
  }
});