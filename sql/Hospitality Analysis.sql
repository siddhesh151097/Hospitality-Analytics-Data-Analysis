use hospitality;

# total revenue 
select * from fact_bookings;
select sum(revenue_realized) as total_revenue from fact_bookings;

# total bookings
select count(booking_id) as total_booking from fact_bookings;
select * from `fact_aggregated_bookings`;

# total capacity 
select sum(capacity) as total_capacity from fact_aggregated_bookings;

#average rating
select avg(ratings_given) as average_rating from fact_bookings;

# occupancy percent
select 
    (SUM(successful_bookings) / SUM(capacity)) * 100 AS occupancy_percent
FROM fact_aggregated_bookings;

#cancellation booking
SELECT 
    (SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) 
     / COUNT(booking_id)) * 100 AS cancellation_percent
FROM fact_bookings;

#total revenue by city and room class
SELECT 
    dh.city,
    fb.room_category,
    SUM(fb.revenue_realized) AS total_revenue
FROM fact_bookings fb
JOIN dim_hotels dh 
    ON fb.property_id = dh.property_id
GROUP BY 
    dh.city,
    fb.room_category
ORDER BY 
    dh.city,
    total_revenue DESC;

# total booking by booking platform
select booking_platform as platform_name,count(booking_id) as total_booking from fact_bookings
group by booking_platform
order by total_booking 
desc; 

# occupancy percent by day types
 select dd.day_type, (SUM(successful_bookings) / SUM(capacity)) * 100 AS occupancy_percent from fact_aggregated_bookings fab
 JOIN dim_date dd 
    ON fab.check_in_date = dd.date
GROUP BY dd.day_type
ORDER BY occupancy_percent
 DESC;
 
 # revenue by city and property name
 select dh.property_name as hotel_name,dh.city as city, sum(revenue_realized) as total_revenue from fact_bookings fb
 join dim_hotels dh
 on fb.property_id = dh.property_id
 group by hotel_name,city
 order by  city, total_revenue
 desc;
 
 #total revenue by booking platform
 select booking_platform as platform_name, sum(revenue_realized) as total_revenue from fact_bookings
 group by platform_name
 order by total_revenue
 desc;
 
 #revenue by successful booking by day type
 select dd.day_type as day_type, sum(fab.successful_bookings) as total_booking,sum(fb.revenue_realized)as total_revenue
 from fact_aggregated_bookings fab
 join dim_date dd
 on fab.check_in_date = dd.date
 join fact_bookings fb
 on fab.property_id = fb.property_id
  AND fab.room_category = fb.room_category
  
 group by day_type
order by  total_booking,total_revenue
 desc;
 
 # revenue by category
 select dh.category as category,sum(revenue_realized)as total_revenue from fact_bookings fb
 join dim_hotels dh
 on dh.property_id = fb.property_id
 group by category
 order by total_revenue
 desc;
 
 #revenue and average rating by property name
 select dh.property_name as hotel_name, round(avg(ratings_given),2)as ratings, sum(revenue_realized)as total_revenue from fact_bookings fb
 join dim_hotels dh
 on dh.property_id = fb.property_id
 group by hotel_name
 order by ratings,total_revenue
 desc;
