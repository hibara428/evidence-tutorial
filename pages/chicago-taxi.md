---
title: Chicago Taxi Trips 2023
---

# Chicago Taxi Trips 2023

BigQueryパブリックデータセット (`bigquery-public-data.chicago_taxi_trips`) を使ったサンプルレポートです。

## 月別トリップ数

```sql monthly_trips
SELECT * FROM bq_public.monthly_trips
```

<LineChart
  data={monthly_trips}
  x=month
  y=trip_count
  title="月別タクシー利用件数 (2023)"
  yAxisTitle="件数"
/>

## 月別平均運賃・平均距離

<BarChart
  data={monthly_trips}
  x=month
  y={["avg_fare", "avg_miles"]}
  title="月別 平均運賃(USD) / 平均距離(mile)"
/>

## 支払い方法別内訳

```sql payment_type
SELECT * FROM bq_public.payment_type
```

<DataTable data={payment_type} />

<BarChart
  data={payment_type}
  x=payment_type
  y=trip_count
  title="支払い方法別トリップ数"
/>
