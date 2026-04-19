-- Chicago taxi trips: breakdown by payment type (2023)
SELECT
  payment_type,
  COUNT(*) AS trip_count,
  ROUND(SUM(fare), 0) AS total_fare,
  ROUND(AVG(tips), 2) AS avg_tip
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE
  trip_start_timestamp BETWEEN '2023-01-01' AND '2023-12-31'
  AND payment_type IS NOT NULL
  AND fare > 0
GROUP BY payment_type
ORDER BY trip_count DESC
LIMIT 10
