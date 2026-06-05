-- Chicago taxi trips: breakdown by payment type x month (2023)
SELECT
  payment_type,
  DATE_TRUNC(trip_start_timestamp, MONTH) AS month,
  COUNT(*) AS trip_count,
  ROUND(SUM(fare), 0) AS total_fare,
  ROUND(AVG(fare), 2) AS avg_fare,
  ROUND(AVG(tips), 2) AS avg_tip,
  ROUND(AVG(trip_miles), 2) AS avg_miles
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE
  trip_start_timestamp BETWEEN '2023-01-01' AND '2023-12-31'
  AND payment_type IN ('Cash', 'Credit Card', 'Mobile')
  AND fare > 0
GROUP BY payment_type, month
ORDER BY payment_type, month
