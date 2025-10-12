## Workbook Context & Analytical Focus

> **“😋 Eclipse Eats”**
>

Eclipse Eats is a fictional international brand I created for a university course project, where I designed its identity, logos, and mockups. The concept features worldwide late-night restaurants delivering unique food and munchies between 00:00–4:00, offering 30 permanent menu items and 10 rotating daily specials.

> 💡The key goal for “Eclipse Eats” will be optimizing delivery operations to ensure profitability and customer satisfaction
>

> **📒 The Workbook**
>

The dataset I built using ChatGPT is a realistic simulation of an international food delivery company. It includes order-level data that captures the essentials of running such a business: when and where orders happen, how deliveries perform, what customers buy, and how much money flows in. Each record connects timing, geography, customer behavior, and financial details, creating a complete picture of operations. This structure makes the file a strong foundation for exploring questions any business would care about - like demand patterns, late deliveries, popular items, or order value, and for practicing how to turn raw information into clear insights through analysis and dashboards.

> **📢 Executive Summary**

The analysis revealed three clear, high-impact opportunities to drive growth for Eclipse Eats. By focusing on customer frequency, delivery efficiency, and intelligent menu bundling, “Eclipse Eats” can significantly increase revenue and improve customer satisfaction.

**1. Focus on Order Frequency, Not Just Order Value.**

The customers spend roughly the same amount per order ($3 variance) regardless of segment. The real growth lever is getting them to order more often.

> **✅ Action:** Retain Eclipse Eats’ most frequent customers (Club-Goers & Gamers) with loyalty programs. Nurture Students & Night-Shift Workers with targeted meal plans and unlock the high-potential Local Residents by testing family-bundle offers to increase their low purchase frequency.
>

**2. Optimize Deliveries with a "Smart Fleet".**

The delivery lateness is driven by a mismatch between vehicle, distance, and weather. A one-size-fits-all approach is failing.

> **✅ Action:** Implement a dynamic dispatch system. In rain, automatically assign scooters for short trips (to avoid parking delays) and cars for long trips (for reliability). This will immediately reduce late orders and improve the customer experience.
>

**3. Increase Average Order Value with Intelligent Bundling.**

Customer purchasing data shows clear patterns. The “Ionian Ice Pop” is a universal add-on, and the Lagrange Lasagna is a common meal anchor.

> **✅ Action:** Program the app to offer smart, automated bundles. When a customer adds Lasagna, prompt them to add a side. When they order a snack, suggest the Ice Pop. These simple "meal deals" and "sweet duos" will drive incremental revenue on every transaction.
>

## The Dashboard

![Dashboard.png](attachment:16ff0c12-07df-47b2-943e-0092f1218dbd:Dashboard.png)

> 📈 For the full interactive Tableau dashboard [click here](https://public.tableau.com/views/EclipseEats-Updated/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
>

The core questions this dashboard answers include:

- *Which customer segments drive AOV for unique items and Which segments place the most distinct orders that include unique items?*
    
    This question helps us see which types of customers spend the most on special menu items and which types of customers buy them most often, so we can understand who really drives sales of the unique dishes at Eclipse Eats.
    
- *How do distance, vehicle, weather affect late deliveries?*
    
    This question helps us understand in simple terms whether the chances of food arriving late depend more on how far it needs to travel, which type of vehicle delivers it, or what the weather is like.
    
- *Which items co-occur and should be bundled?*
    
    This question helps the business discover which foods customers often buy together so they can be offered as bundles that make ordering easier and increase sales.
    

## **Data Cleaning & Preparation Plan**

> 💡 For this, I created a new sheet called Clean_Data, to keep a backup of the original raw data.
>

![image.png](attachment:468753cb-1d91-43a2-99d1-8ea6861d893d:image.png)

> ###📊 Make time usable across time zones
>
> **WHY❓** 
>
> All analyses hinge on the 00:00–04:00 local window. Text timestamps break time math and cross-TZ comparisons.
>
> **HOW**❓ 
> Converted `Local_Datetime` from text to true Date/Time via **Data → Text to Columns → Delimited → Date (YMD)**.
>
> **Validation**
> Spot checks with `=ISNUMBER()`.
>

> ###📊 Numeric hygiene for money fields
>
> **WHY❓** 
>
> Prices, tips, discounts must be numeric to avoid silent errors in totals.
>
> **HOW**❓ 
> Temporary checks with `=ISNUMBER(ref)`. Where needed, removed stray symbols, standardized decimals. For readability in the *clean view* only, applied currency format (raw values remain plain numbers).
>
> **Validation**
> Random row audits and quick distribution scans (e.g., tips not negative).
>
> ****By doing so, I prevented aggregation errors and made finance metrics trustworthy.
>

> ###📊 Promo intensity: `Discount_Rate`
>
> **WHY❓** 
>
> I wanted a quick signal for promotions relative to basket value.
>
> **HOW**❓ 
> New column `Discount_Rate = IF(Items_Value>0, Discount/Items_Value, 0)` formatted as % (display only).
>
> **Validation**
> Looked for outliers (>100%) to catch data issues.
>
> ****It gave me a fast way to segment orders by promo pressure and spot abnormal rows.
>

> ###📊 **Financial consistency check**
>
> **WHY❓** 
> Ensure `Total_Order_Value` matches the arithmetic `Items_Value + Tip – Discount`.
>
> **HOW**❓ 
> `Financial_Validation = ROUND([@[Items_Value]] + [@Tip] - [@Discount], 2) = ROUND([@[Total_Order_Value]], 2)` and filtered to `FALSE`.
>
> **What I Found**
> A cluster of `FALSE` rows where `Total_Order_Value` was effectively zero because **Discount > Items_Value**
>
> **Decision**
> Logged as **Data Quality Issue #1** and flagged these orders. For analysis:
>
> - Excluded them from revenue KPIs (to avoid inflating promo losses).
> - Kept them in operational metrics (they still affect load, delivery, etc.).
>
> ****It prevented downstream margin distortion and documented a business rule candidate (cap discounts at basket value or record excess as “promo credit”).
>

> ###📊 **Time logic sanity: `Delivery_Time_Min ≥ Prep_Time_Min`**
>
> **WHY❓** 
> Delivery should include prep; violations indicate entry errors.
>
> **HOW**❓ 
> `Time_Validation = [@Delivery_Time_Min] >= [@Prep_Time_Min]`.
>
> **What I Found**
> **4 rows (0.07%)** were `FALSE`, clustered in **Singapore, Jerusalem, and LA**.
>
> **Decision**
> Logged as **Data Quality Issue #2** and **removed** them (tiny share, clearly illogical).
>
> ****It removed noise from SLA distributions and average delivery time metrics
>

> ###📊 Analysis helpers (readability + segmentation)
>
> **Has_Daily_Unique:**
>
> **WHY❓** 
> Easily segment orders containing a rotating daily special
>
> **HOW**❓ 
> `=IF([@Daily_Unique_In_Order]=1,"Yes","No")`.
>
> It provided clear pivots on the performance of limited-time items.
>
> **Distance_Bucket:**
>
> **WHY❓** 
> Turn skewed continuous `Distance_km` into actionable bands.
>
> **HOW**❓ 
> `=IF([@[Distance_km]]<=1,"Short (<1km)",IF([@[Distance_km]]<=3,"Medium (1–3km)","Long (>3km)"))`.
>
> It provided crisp comparisons of ETA, tips, and on-time rates by trip length.
>

> ###📊 Count all items per order
>
> **WHY❓** 
> Pivot analysis showed `Items_Count` stuck at `0`, even when multiple items were ordered. This column should represent the **sum of Item1_Qty, Item2_Qty, and Item3_Qty**, but blank cells prevented totals.
>
> **HOW**❓ 
>
> In `Clean_Data`, replaced static `0` with a structured reference formula in the `Items_Count` column:
>
> ```
> =SUM([@[Item1_Qty]], [@[Item2_Qty]], [@[Item3_Qty]])
> ```
>
> **Validation:**
>
> Spot-checked rows: orders with `Item1_Qty=2, Item2_Qty=1, Item3_Qty=0` → `Items_Count=3`. Confirmed pivot values update correctly.
>

> ###📊 Compute daily-unique item quantities
>
> **WHY❓** 
> KPIs for the “daily menu” under-counted demand. We only had a boolean `Daily_Unique_In_Order`, but not **quantities** per slot. We need per-slot quantities that treat blanks safely and follow the SKU rule: **permanent items start with “P”; any other prefix = daily unique**.
>
> **HOW**❓ 
>
> Added three new columns in `Clean_Data`, each returning the qty only when the item is a daily-unique; otherwise `0`.
>
> ```
> ' Daily_Unique_Qty_1
> =IFERROR(IF(ISERROR(SEARCH("P",[@[Item1_ID]])), [@[Item1_Qty]], 0), 0)
>
> ' Daily_Unique_Qty_2
> =IFERROR(IF(ISERROR(SEARCH("P",[@[Item2_ID]])), [@[Item2_Qty]], 0), 0)
>
> ' Daily_Unique_Qty_3
> =IFERROR(IF(ISERROR(SEARCH("P",[@[Item3_ID]])), [@[Item3_Qty]], 0), 0)
> ```
>
> Then, I created new column `Total_Daily_Unique_Items` in `Clean_Data`:
>
> ```
> =IF([@[Has_Daily_Unique]]="Yes", [@[Daily_Unique_Qty_1]]+[@[Daily_Unique_Qty_2]]+[@[Daily_Unique_Qty_3]], 0)
> ```
>
> **Validation:**
>
> Spot-checks:
>
> - `Item1_ID="B12", Item1_Qty=2` → `Daily_Unique_Qty_1=2`
> - `Item2_ID="P07", Item2_Qty=1` → `Daily_Unique_Qty_2=0`
> - Blank `Item3_*` → `Daily_Unique_Qty_3=0` (via `IFERROR`).
>    
>     Confirmed pivot totals for daily uniques now match manual sums.
>    
>

### Data Quality Log

| **Issue** | **Description** | **Investigation** | **Action Taken** |
| --- | --- | --- | --- |
| Financial Mismatch | `Total_Order_Value` = 0 while `Items_Value + Tip – Discount > 0`; discounts exceeded basket value | Filtered FALSE in `Financial_Validation`; confirmed arithmetic | Flagged; excluded from revenue KPIs; proposed discount cap rule |
| Logical Time Error | 4 rows where `Delivery_Time_Min < Prep_Time_Min` (0.07%) | Concentrated in Singapore, Jerusalem, LA | Deleted rows |
| Items Count Incorrect | `Items_Count` = 0 for all rows despite item quantities present | Found formula missing aggregation across Item1–3 | Replaced with `=SUM([@[Item1_Qty]],[@[Item2_Qty]],[@[Item3_Qty]])`; validated with sample rows |

### Result

After these steps, the dataset is **type-correct, auditable, and analysis-ready**. The checks are lightweight, reproducible, and documented. Most importantly, they protect core metrics - on-time performance, revenue, and promo efficiency, so insights reflect operations, not artifacts.

## Answering Key Business Questions for Eclipse Eats

### **Q1 - Which customer segments drive AOV for unique items and Which segments place the most distinct orders that include unique items?**

![Q1.png](attachment:102432dc-5447-4811-a5a7-4c3ea1e4f287:Q1.png)

**Insights & Recommendations**

- no single segment truly drives AOV. The difference between the highest and lowest AOV is only $3. This suggests that when customers decide to order a special, they tend to build a cart of similar total value, regardless of their segment. This could be due to menu pricing, popular combo deals, or a natural price point for a late-night meal. Therefore, focusing on increasing AOV may be less effective than focusing on increasing order frequency.
- the segments that place the most orders including unique items are the Club-Goers and Gamers, with Club-Goers placing 130 orders and Gamers placing 118 orders. Following them, Students and Night-Shift workers form a reliable secondary tier with 91 and 85 orders respectively. The remaining segments, including Early Commuters with 39 orders, Local Residents with 36 orders, and Tourists with 31 orders, represent a long tail of infrequent purchasers.

> **➡️ Recommendation:** Retain the highest-volume segments, Club-Goers and Gamers, by implementing gamified loyalty programs and curating menu specials that appeal directly to their lifestyles.
>

> **➡️ Recommendation: I**ncrease the low order frequency of high-spending Local Residents by first analyzing their basket size to determine if they need premium single-meal promotions or family-bundle offers.
>

> **➡️ Recommendation:** Nurture the Students and Night-Shift segments into core customers by promoting study-group bundles to increase average order value and offering weekly meal plans to boost their purchase frequency.
>

### **Q2 -** How do distance, vehicle, weather affect late deliveries?

![Q2.png](attachment:c808d6a5-16b1-481d-9228-71232a2dda7f:6708fee0-0cbc-47da-8766-90e8850b63c0.png)

**Insights & Recommendations**

- In short distance, The most striking anomaly is the 7.5% lateness rate for cars in the rain. This is counterintuitive. A car should be fast over <1km. This suggests the issue isn't travel speed but likely parking and building access. A driver may spend several minutes finding parking and walking to the customer's door, a problem exacerbated by rain. Bikes and scooters are far more efficient for these short trips, even in the rain.
- In medium distance, This is the most competitive segment. In clear weather, cars are the least efficient (9.2% late). However, in the rain, cars become the most reliable option (9.0% late), while bike and scooter performance degrades significantly (10.8% and 9.8% late, respectively).
- In long distance, Cars are the clear winner in adverse conditions. In the rain, the car lateness rate (37.7%) is substantially lower than for bikes (54.1%) and scooters (52.1%). The protection from the elements allows for more consistent travel times over longer stretches.

> **➡️ Recommendation: A f**leet heavily reliant on scooters is optimal for urban areas where most deliveries are likely short-to-medium distance. They offer a good balance of speed and resilience.
>

> **➡️ Recommendation:** “Eclipse Eats” ****need to automatically assign the smartest vehicle for every order. When it rains, scooters are best for short trips while cars are much better for long ones to make sure food arrives on time.
>

> **➡️ Recommendation:** For long distance deliveries in the rain, “Eclipse Eats” should be upfront with customers and give them a longer, more realistic delivery time and could also temporarily stop delivering to faraway places during bad weather to avoid very late orders.
>

### **Q3 - Which items co-occur and should be bundled?**

![Q3.png](attachment:ae231b81-f0db-4fd9-8238-d3ada739245d:Q3.png)

**Insights & Recommendations**

- The Ionian Ice Pop shows up in many order pairs which means people often buy it together with both sweet and savory foods so it works well as a cross-sell item.
- The Lagrange Lasagna is the main course that people often build their meal around and they add sides or desserts to complete it.
- Customers usually order in two main ways either a full meal with a main dish plus extras or a snack and dessert combo for a late night treat.

> **➡️ Recommendation:** Make special bundles like a sweet duo or a meal deal to help customers choose quickly and spend a little more.
>

> **➡️ Recommendation:** Show smart suggestions in the app so when someone picks the Ice Pop or Lasagna they get an easy prompt to add a matching item.
>

> **➡️ Recommendation:** Test different ways of offering bundles to see which one works best and track if people buy more finish more orders and keep profits healthy.
>

[LinkedIn](https://www.linkedin.com/in/ohad-koriat/) / [ohadkoriat@gmail.com](mailto:ohadkoriat@gmail.com) / 050-597-5718

© 2025 Ohad Koriat. All Rights Reserved.
