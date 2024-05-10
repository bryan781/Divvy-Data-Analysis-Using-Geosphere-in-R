library(ggplot2)
install.packages("geosphere") 
library(geosphere)
library(tidyverse)
library("skimr")
library("janitor")

bike1<-read_csv("C:/Users/Bryan/Documents/R tutorial/202207-divvy-tripdata.csv")
bike2<-read_csv("C:/Users/Bryan/Documents/R tutorial/202208-divvy-tripdata.csv")
bike3<-read_csv("C:/Users/Bryan/Documents/R tutorial/202209-divvy-publictripdata.csv")
bike4<-read_csv("C:/Users/Bryan/Documents/R tutorial/202210-divvy-tripdata.csv")
bike5<-read_csv("C:/Users/Bryan/Documents/R tutorial/202211-divvy-tripdata.csv")
bike6<-read_csv("C:/Users/Bryan/Documents/R tutorial/202212-divvy-tripdata.csv")
bike7<-read_csv("C:/Users/Bryan/Documents/R tutorial/202301-divvy-tripdata.csv")
bike8<-read_csv("C:/Users/Bryan/Documents/R tutorial/202302-divvy-tripdata.csv")
bike9<-read_csv("C:/Users/Bryan/Documents/R tutorial/202303-divvy-tripdata.csv")
bike10<-read_csv("C:/Users/Bryan/Documents/R tutorial/202304-divvy-tripdata.csv")
bike11<-read_csv("C:/Users/Bryan/Documents/R tutorial/202305-divvy-tripdata.csv")
bike12<-read_csv("C:/Users/Bryan/Documents/R tutorial/202306-tripdata.csv")

glimpse(bike12)

trip<-bind_rows(bike1,bike2,bike3,bike4,bike5,
                bike6,bike7,bike8,bike9,bike10,
                bike11,bike12)

trip$month<-format(as.Date(trip$started_at),"%b")
trip$year<-format(as.Date(trip$started_at),"%Y")
trip$day_of_week<-format(as.Date(trip$started_at),"%A")

trip <- trip %>%
  mutate(hour = strftime(trip$ended_at, "%H"))

trip$ride_length <- (as.double(difftime(trip$ended_at, trip$started_at))) /60

trip$ride_distance <- distGeo(matrix(c(trip$start_lng, trip$start_lat), ncol = 2),
                               matrix(c(trip$end_lng, trip$end_lat), ncol = 2))

trip$ride_distance <- trip$ride_distance/1000

trip$day_of_week <- ordered(trip$day_of_week, levels = c("Monday", "Tuesday", "Wednesday", 
                                                           "Thursday", "Friday", "Saturday", 
                                                           "Sunday"))


trip$month <- ordered(trip$month, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

names(trip) [2] <- 'bike'
names(trip) [13] <- 'user'

trip <- drop_na(trip)


trip <- trip[!trip$ride_length < 1,]


trip <- trip[!trip$ride_length > 1440,]



user_count<-trip %>% 
  group_by(user) %>%
  summarize(total = n()) %>%
  mutate(overall_total = sum(total)) %>%
  group_by(user) %>%
  summarize(percent_total = total/overall_total)

user_count

bike_usage <- trip %>%
  group_by(bike) %>%
  summarize(total = n()) %>%
  mutate(overall_total = sum(total)) %>%
  group_by(bike) %>%
  summarize(percent_total = total/overall_total) 

bike_usage

casual_member_biketype_used <- trip %>%
  filter(user == "casual") %>%
  group_by(bike) %>%
  summarize(total = n()) %>%
  mutate(overall_total = sum(total)) %>%
  group_by(bike) %>%
  summarize(percent_casual = total/overall_total)

casual_member_biketype_used

annual_member_biketype_used <- trip %>%
  filter(user == "member") %>%
  group_by(bike) %>%
  summarize(total = n()) %>%
  mutate(overall_total = sum(total)) %>%
  group_by(bike) %>%
  summarize(percent_casual = total/overall_total)

annual_member_biketype_used

riders_time_user <- trip %>%
  group_by(user) %>%
  summarize(avg_time = mean(ride_length), .groups = "drop")


riders_time_user$avg_time <- round(riders_time_user$avg_time , digits = 0)

riders_time_user


riders_time_biketypes <- trip %>%
  group_by(bike, user) %>%
  summarize(avg_time = mean(ride_length), .groups = "drop")

riders_time_biketypes$avg_time <- round(riders_time_biketypes$avg_time , digits = 0)

riders_time_biketypes

riders_dist_user <- trip %>%
  group_by(user) %>%
  summarize(avg_dist = mean(ride_distance), .groups = "drop")

riders_dist_user$avg_dist <- round(riders_dist_user$avg_dist , digits = 2)

riders_dist_user

riders_dist_biketypes <- trip %>%
  group_by(bike, user) %>%
  summarize(avg_dist = mean(ride_distance), .groups = "drop")

riders_dist_biketypes$avg_dist <- round(riders_dist_biketypes$avg_dist , digits = 2)

riders_dist_biketypes

avgridetime <- trip %>% 
  group_by(user) %>%
  summarise(avgtime = mean(ride_length))

avgridetime$avgtime <- round(avgridetime$avgtime, digits = 0)

avgridetime


avgridedist <- trip %>%
  group_by(user) %>%
  summarise(avgdist = mean(ride_distance))

avgridedist$avgdist <- round(avgridedist$avgdist, digits = 3)

avgridedist


hour <- trip %>%
  group_by(user, hour) %>% 
  summarise(numberofrides = n(),.groups = 'drop') %>% 
  arrange(hour)

print(hour)

dayofweek <- trip %>%
  group_by(user, day_of_week) %>% 
  summarise(numberofrides = n(),.groups = "drop")

dayofweek

month <- trip %>% 
  group_by(user, month) %>% 
  summarise(numberofrides = n(),.groups = "drop")

month

options(repr.plot.width = 8, repr.plot.height = 8)

ggplot(user_count, aes(x = "", y = percent_total, fill = user)) +
  geom_col(color = "grey20", size = 0.7) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = scales :: percent(percent_total)), position = position_stack(vjust = 0.5), size = 10, fontface = "bold", color = "#46465e") +
  scale_fill_manual(values = c("#91d8e0", "#42a0ab"), name = "Types of riders", breaks = c("casual", "member"), labels = c("Casual", "Annual Member")) +
  labs(title = "Distribution of Riders", subtitle = "What percentage of riders are using the Cyclistic?",
       caption = "Data: Motivate International") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold", color = "#42a0ab"),
        plot.subtitle = element_text(hjust = 0.5, size = 16, face = "bold", color = "grey20"),
        plot.caption = element_text(size = 8, color = "grey35"),
        legend.title = element_text(size = 16, face = "bold", color = "#42a0ab"),
        legend.text = element_text(size = 14, color = "grey20"))

options(repr.plot.width = 10, repr.plot.height = 6)

ggplot(bike_usage, aes(x = bike, y = percent_total, fill = percent_total)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = scales :: percent(percent_total)), vjust = 1.35, size = 8, fontface = "bold", color = "grey20") + 
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  labs(title = "Percentage of bike-used by casual riders", subtitle = "Seven out of ten riders used the classic biken on rides over the last twelve months",
       caption = "Data: Motivate International", x = "Types of bikes", y = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 16, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.text.x = element_text(size = 14, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 10, repr.plot.height = 6)

ggplot(casual_member_biketype_used, aes(x = bike, y = percent_casual, fill = percent_casual)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = scales :: percent(percent_casual)), vjust = 2, size = 8, fontface = "bold", color = "grey20") + 
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  labs(title = "Percentage of bike-used by casual riders", subtitle = "Casual riders majority pick the classic bike for there ride",
       caption = "Data: Motivate International", x = "Types of bikes", y = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 16, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 14, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 8, repr.plot.height = 6)

ggplot(annual_member_biketype_used, aes(x = bike, y = percent_casual, fill = percent_casual)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = scales :: percent(percent_casual)), vjust = 2, size = 8, fontface = "bold", color = "#46465e") + 
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  labs(title = "Percentage of bike-used by annual riders", subtitle = "Annual members tend to use the classic bike",
       caption = "Data: Motivate International", x = "Type of bikes", y = "") +
  theme_minimal() +
  theme(plot.title = element_text( size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 16, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 14, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 8, repr.plot.height = 6)

ggplot(riders_time_user, aes(x = user, y = avg_time, fill = avg_time)) +
  geom_col(width = 0.8) + 
  geom_text(aes(label = avg_time), vjust = 2, size = 8, color = "grey20", fontface = "bold") +
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  labs(title = "Average time spent by riders on bikes", subtitle = "Casual riders spend twice as long as members on average",
       caption = "Data: Motivate International", x = "User", y = "Time (mins)") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.text.x = element_text(size = 14, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 8, repr.plot.height = 6)

ggplot(riders_time_biketypes, aes(x = bike, y = avg_time, fill = avg_time)) +
  geom_col() + 
  geom_text(aes(label = avg_time), vjust = 2, size = 8, color = "grey20", fontface = "bold") +
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  facet_wrap(~user) +
  labs(title = "Average time spent by riders on bikes", subtitle = "On the average, casual riders using docked bikes spend the most time on rides",
       caption = "Data: Motivate International", x = "Type of Bike", y = "Average time spent (mins)") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.text.x = element_text(size = 10, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 8, repr.plot.height = 6)

ggplot(riders_dist_user, aes(x = user, y = avg_dist, fill = avg_dist)) +
  geom_col(width = 0.8) + 
  geom_text(aes(label = avg_dist), vjust = 2, size = 8, color = "grey20", fontface = "bold") +
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  labs(title = "Average distance travelled by riders on bikes", subtitle = "On the average, casual riders go slightly father than members",
       caption = "Data: Motivate International", x = "User", y = "Average distance (km)") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.text.x = element_text(size = 14, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 8, repr.plot.height = 6)

ggplot(riders_dist_biketypes, aes(x = bike, y = avg_dist, fill = avg_dist)) +
  geom_col() + 
  geom_text(aes(label = avg_dist), vjust = 2, size = 8, color = "grey20", fontface = "bold") +
  scale_fill_gradient(high = "#42a0ab", low = "#91d8e0") +
  facet_wrap(~user) +
  labs(title = "Average time spent by riders on bikes", subtitle = "Both casual and members ride the electric bike the farthest",
       caption = "Data: Motivate International", x = "Type of Bike", y = "Average distance (km)") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.text.x = element_text(size = 10, color = "grey20", face = "bold"),
        axis.text.y = element_blank(),
        legend.position = "none")


options(repr.plot.width = 12, repr.plot.height = 8)
options(scipen=999)

ggplot(hour, aes(hour, numberofrides, fill = user, group = user)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#91d8e0", "#42a0ab"), name = "Types of riders", breaks = c("casual", "member"), labels = c("Casual", "Annual Member")) +
  labs(title = "Rides Throughout the Day", subtitle = "Rides peak during early evening hours",
       caption = "Data: Motivate International",
       x = "Hour", y = "Number of Rides") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        legend.title = element_text(size = 16, face = "bold", color = "#42a0ab"),
        legend.text = element_text(size = 14, color = "grey20"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"),
        axis.text.x = element_text(size = 10, color = "grey20", face = "bold"),
        axis.text.y = element_text(size = 10, color = "grey20", face = "bold"))


options(repr.plot.width = 12, repr.plot.height = 8)
options(scipen=999)


ggplot(dayofweek, aes(day_of_week, numberofrides, fill = user, group = user)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#91d8e0", "#42a0ab"), name = "Types of riders", breaks = c("casual", "member"), labels = c("Casual", "Annual Member")) +
  labs(title = "Day of the Week Riders", subtitle = "Rides happened the most during the weekend",
       caption = "Data: Motivate International",
       x = "Day of Week", y = "Number of Rides") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        legend.title = element_text(size = 16, face = "bold", color = "#42a0ab"),
        legend.text = element_text(size = 14, color = "grey20"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"),
        axis.text.x = element_text(size = 10, color = "grey20", face = "bold"),
        axis.text.y = element_text(size = 10, color = "grey20", face = "bold"))


options(repr.plot.width = 12, repr.plot.height = 8)
options(scipen=999)


ggplot(month, aes(month, numberofrides, fill = user, group = user)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#91d8e0", "#42a0ab"), name = "Types of riders", breaks = c("casual", "member"), labels = c("Casual", "Annual Member")) +
  labs(title = "Monthly Rides",
       caption = "Data: Motivate International", subtitle = "The summer months have the most number of rides",
       x = "Month", y = "Number of Rides") +
  theme_minimal() +
  theme(plot.title = element_text(size = 22, color = "#42a0ab", face = "bold"), 
        plot.subtitle = element_text(size = 14, color = "grey20", face = "bold"), 
        plot.caption = element_text(size = 8, color = "grey35"),
        legend.title = element_text(size = 16, face = "bold", color = "#42a0ab"),
        legend.text = element_text(size = 14, color = "grey20"),
        axis.title.x = element_text(size = 15, color = "#42a0ab", face = "bold"), 
        axis.title.y = element_text(size = 15, color = "#42a0ab", face = "bold"),
        axis.text.x = element_text(size = 10, color = "grey20", face = "bold"),
        axis.text.y = element_text(size = 10, color = "grey20", face = "bold"))
