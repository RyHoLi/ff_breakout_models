drop table qb_breakout_data;
create table qb_breakout_data as 
select
	t1.player_id
	, t1.name
	, t1.age
	, t1.draft_round
	, t1.draft_pick
	, t1.height
	, t1.weight
	, t1.season
	, t2.season as pred_season
	, CASE WHEN t1.completions IS NULL THEN 0 ELSE t1.completions END AS completions
	, CASE WHEN t1.attempts IS NULL THEN 0 ELSE t1.attempts END AS attempts
	, CASE WHEN t1.passing_yards IS NULL THEN 0 ELSE t1.passing_yards END AS passing_yards
	, CASE WHEN t1.passing_tds IS NULL THEN 0 ELSE t1.passing_tds END AS passing_tds
	, CASE WHEN t1.interceptions IS NULL THEN 0 ELSE t1.interceptions END AS interceptions
	, CASE WHEN t1.sacks IS NULL THEN 0 ELSE t1.sacks END AS sacks
	, CASE WHEN t1.sack_fumbles_lost IS NULL THEN 0 ELSE t1.sack_fumbles_lost END AS sack_fumbles_lost
	, CASE WHEN t1.adot IS NULL THEN 0 ELSE t1.adot END AS adot
	, CASE WHEN t1.passing_yac IS NULL THEN 0 ELSE t1.passing_yac END AS passing_yac
	, CASE WHEN t1.firstdowns_per_att IS NULL THEN 0 ELSE t1.firstdowns_per_att END AS firstdowns_per_att
	, CASE WHEN t1.passing_epa IS NULL THEN 0 ELSE t1.passing_epa END AS passing_epa
	, CASE WHEN t1.dakota IS NULL THEN 0 ELSE t1.dakota END AS dakota
	, CASE WHEN t1.carries IS NULL THEN 0 ELSE t1.carries END AS carries
	, CASE WHEN t1.rushing_yards IS NULL THEN 0 ELSE t1.rushing_yards END AS rushing_yards
	, CASE WHEN t1.rushing_tds IS NULL THEN 0 ELSE t1.rushing_tds END AS rushing_tds
	, CASE WHEN t1.rushing_first_downs IS NULL THEN 0 ELSE t1.rushing_first_downs END AS rushing_first_downs
	, CASE WHEN t1.rushing_epa	 IS NULL THEN 0 ELSE t1.rushing_epa END AS rushing_epa
	, t1.fantasy_points
	, t2.fantasy_points as pred_fantasy_points
	, ((t2.fantasy_points - t1.fantasy_points) / NULLIF(t1.fantasy_points,0)::FLOAT)::DECIMAL(5,2) AS pct_increase
	, CASE 
		WHEN ((t2.fantasy_points - t1.fantasy_points) / NULLIF(t1.fantasy_points,0)::FLOAT)::DECIMAL(5,2) >= .2
		AND t2.fantasy_points >= 19 AND t2.gp >= 12 THEN 1	
		WHEN ((t2.fantasy_points - t1.fantasy_points) / NULLIF(t1.fantasy_points,0)::FLOAT)::DECIMAL(5,2) >= .3
		AND t2.fantasy_points >= 17 AND t2.gp >= 12 THEN 1	
		ELSE 0
	END AS breakout
FROM 
(select
	a.player_id
	, b.name
	, CASE 
		WHEN a.season = 2021 THEN (EXTRACT(year from '2021-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2020 THEN (EXTRACT(year from '2020-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2019 THEN (EXTRACT(year from '2019-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2018 THEN (EXTRACT(year from '2018-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2017 THEN (EXTRACT(year from '2017-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2016 THEN (EXTRACT(year from '2016-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        WHEN a.season = 2015 THEN (EXTRACT(year from '2015-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2014 THEN (EXTRACT(year from '2014-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2013 THEN (EXTRACT(year from '2013-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2012 THEN (EXTRACT(year from '2012-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2011 THEN (EXTRACT(year from '2011-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2010 THEN (EXTRACT(year from '2010-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2009 THEN (EXTRACT(year from '2009-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2008 THEN (EXTRACT(year from '2008-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2007 THEN (EXTRACT(year from '2007-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2006 THEN (EXTRACT(year from '2006-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2005 THEN (EXTRACT(year from '2005-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        ELSE 0
			  END AS age
	, CASE WHEN b.draft_round IS NULL then 8 ELSE b.draft_round END AS draft_round
	, CASE WHEN b.draft_pick IS NULL THEN 32 ELSE b.draft_pick END AS draft_pick
	, b.height
	, b.weight
	, a.season
 	, c.gp
	, (completions::float / NULLIF(attempts,0))::DECIMAL(5,2) AS completions
	, attempts
	, (passing_yards::float / NULLIF(attempts,0))::DECIMAL(5,2) AS passing_yards
	, (passing_tds::float / NULLIF(attempts,0))::DECIMAL(5,2) AS passing_tds
	, (interceptions::float / NULLIF(attempts,0))::DECIMAL(5,2) AS interceptions
	, (sacks::float / NULLIF(attempts,0))::DECIMAL(5,2) AS sacks
	, (sack_fumbles_lost::float / NULLIF(attempts,0))::DECIMAL(5,2) AS sack_fumbles_lost
	, (passing_air_yards::float / NULLIF(attempts,0))::DECIMAL(5,2) AS adot
	, (passing_yards_after_catch::float / NULLIF(attempts,0))::DECIMAL(5,2) AS passing_yac
	, (passing_first_downs::float / NULLIF(attempts,0))::DECIMAL(5,2) AS firstdowns_per_att
	, (passing_epa::float / NULLIF(attempts,0))::DECIMAL(5,2) AS passing_epa
	, dakota::DECIMAL(5,2) AS dakota
	, carries
	, (rushing_yards::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_yards
	, (rushing_tds::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_tds
	, (rushing_first_downs::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_first_downs
	, (rushing_epa::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_epa		
	, (fantasy_points::float / NULLIF(gp,0))::DECIMAL(5,2) AS fantasy_points
FROM nfl_seasonal a
JOIN player_mapping b ON (a.player_id = b.gsis_id)
JOIN (SELECT player_id, season, COUNT(*) as gp FROM nfl_weekly WHERE attempts >= 1 GROUP BY 1,2) c 
ON (a.player_id = c.player_id AND a.season = c.season )
WHERE b.position = 'QB') t1
LEFT JOIN 
(select
	a.player_id
	, b.name
	, CASE 
		WHEN a.season = 2021 THEN (EXTRACT(year from '2021-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2020 THEN (EXTRACT(year from '2020-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2019 THEN (EXTRACT(year from '2019-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2018 THEN (EXTRACT(year from '2018-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2017 THEN (EXTRACT(year from '2017-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2016 THEN (EXTRACT(year from '2016-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        WHEN a.season = 2015 THEN (EXTRACT(year from '2015-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2014 THEN (EXTRACT(year from '2014-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2013 THEN (EXTRACT(year from '2013-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2012 THEN (EXTRACT(year from '2012-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2011 THEN (EXTRACT(year from '2011-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2010 THEN (EXTRACT(year from '2010-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2009 THEN (EXTRACT(year from '2009-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2008 THEN (EXTRACT(year from '2008-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2007 THEN (EXTRACT(year from '2007-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2006 THEN (EXTRACT(year from '2006-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2005 THEN (EXTRACT(year from '2005-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        ELSE 0
 		END AS age
	, b.draft_round
	, b.draft_pick
	, b.height
	, b.weight
	, a.season	
 	, c.gp
	, (fantasy_points::float / NULLIF(gp,0))::DECIMAL(5,2) AS fantasy_points
FROM nfl_seasonal a
JOIN player_mapping b ON (a.player_id = b.gsis_id)
JOIN (SELECT player_id, season, COUNT(*) as gp FROM nfl_weekly WHERE attempts >= 1 GROUP BY 1,2) c 
ON (a.player_id = c.player_id AND a.season = c.season ) 
WHERE b.position = 'QB') t2 
ON (t1.player_id = t2.player_id
AND t1.season = t2.season - 1)

COPY qb_breakout_data TO 'C:/Users/Ryan/OneDrive/Documents/nfl_models/data/qb_breakout_data.csv' csv header;

