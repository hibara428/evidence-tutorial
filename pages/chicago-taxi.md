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

---

## テーブルのグループ表現

### 1. アコーディオン（行の展開ドリルダウン）

支払い方法ごとに折りたたまれており、クリックで月次明細が展開します。

```sql payment_monthly
SELECT * FROM bq_public.payment_monthly
```

<DataTable
  data={payment_monthly}
  groupBy=payment_type
  groupType=accordion
  subtotals=true
  totalRow=true
  groupsOpen=false
  rows=50
>
  <Column id=payment_type title="支払い方法" totalAgg=countDistinct totalFmt='0 "種類"'/>
  <Column id=month title="月"/>
  <Column id=trip_count title="件数" contentType=colorscale/>
  <Column id=total_fare title="売上合計" fmt=usd0k totalAgg=sum/>
  <Column id=avg_fare title="平均運賃" fmt=usd2 totalAgg=mean/>
  <Column id=avg_tip title="平均チップ" fmt=usd2 totalAgg=mean/>
  <Column id=avg_miles title="平均距離(mi)" fmt="0.00" totalAgg=mean/>
</DataTable>

---

### 2. カラムグループ（列ヘッダーの2段構造）

複数の指標を「走行データ」「料金データ」にまとめた2段ヘッダーです。

<DataTable
  data={payment_monthly}
  groupBy=payment_type
  groupType=section
  subtotals=true
  totalRow=true
>
  <Column id=payment_type title="支払い方法" totalAgg=countDistinct totalFmt='0 "種類"'/>
  <Column id=month title="月"/>
  <Column id=trip_count title="件数" totalAgg=sum colGroup="走行データ"/>
  <Column id=avg_miles title="平均距離(mi)" fmt="0.00" totalAgg=mean colGroup="走行データ"/>
  <Column id=total_fare title="売上合計" fmt=usd0k totalAgg=sum colGroup="料金データ"/>
  <Column id=avg_fare title="平均運賃" fmt=usd2 totalAgg=mean colGroup="料金データ"/>
  <Column id=avg_tip title="平均チップ" fmt=usd2 totalAgg=mean colGroup="料金データ"/>
</DataTable>
