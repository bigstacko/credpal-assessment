const express = require("express");
const redis = require("redis");

const app = express();
app.use(express.json());

const PORT = 3000;
const REDIS_URL = process.env.REDIS_URL || "redis://localhost:6379";

const redisClient = redis.createClient({ url: REDIS_URL });
redisClient.connect().catch(console.error);

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/status", async (req, res) => {
  const processed = await redisClient.get("processed") || 0;
  res.json({ processed: Number(processed) });
});

app.post("/process", async (req, res) => {
  let count = await redisClient.get("processed") || 0;
  count++;
  await redisClient.set("processed", count);

  res.json({ message: "Processed successfully", count });
});

app.listen(PORT, () => {
  console.log(`Application running on port ${PORT}`);
});