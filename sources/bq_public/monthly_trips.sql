-- Chicago taxi trips: monthly summary
SELECT
  DATE_TRUNC(trip_start_timestamp, MONTH) AS month,
  COUNT(*) AS trip_count,
  ROUND(AVG(trip_seconds) / 60, 1) AS avg_duration_min,
  ROUND(AVG(trip_miles), 2) AS avg_miles,
  ROUND(AVG(fare), 2) AS avg_fare
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE
  trip_start_timestamp BETWEEN '2023-01-01' AND '2023-12-31'
  AND trip_seconds > 0
  AND trip_miles > 0
  AND fare > 0
GROUP BY month
ORDER BY month
