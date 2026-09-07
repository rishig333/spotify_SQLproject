DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
--1
select * from spotify
limit 10;

--2
select count(distinct album) from spotify;

--3
select * from spotify 
where stream > 1000000000;

--4
select  distinct album , artist from spotify ;

--5
select sum(comments) as Total_comments from spotify where licensed = 'true';

--6
select * from spotify where album_type='single'

--7
select artist , count(*) as Total_songs from spotify group by artist

--8
select album , avg(danceability) as avg_danceability from spotify group by album order by album desc

--9
select track , max(energy) from spotify group by track order by track desc  limit 5

--10
select track , sum(views) as total_views , sum(likes) as total_likes from spotify  where official_video='true'
group by track

--11
select album , track, sum(views) as total_views from spotify group by album , track

--12
select * from 
(select track,
coalesce(sum(case when most_played_on = 'Youtube' then stream END),0) as streamed_on_youtube,
coalesce(sum(case when most_played_on = 'Spotify' then stream END),0) as streamed_on_spotify
from spotify group by track) as t1
where streamed_on_spotify > streamed_on_youtube and  streamed_on_youtube <> 0

--13
with ranking_artist as (
select artist , track ,  sum(views) as total_views , 
dense_rank() over(partition by artist order by sum(views) desc ) as rank
from spotify group by artist , track 
order by artist , sum(views) desc
) select * from ranking_artist 
where rank <=3

--14
select  track , artist , liveness  from  spotify where liveness >(select avg(liveness) from  spotify) 

--15
with cte as (
select album,  max(energy)as highest_energy ,
min(energy) as lowest_energy from spotify
group by album )
select album , highest_energy-lowest_energy as enerfy_difference from cte
