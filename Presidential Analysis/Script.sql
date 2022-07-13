--DELETE duplicates
"""
DELETE FROM presidential_aspirant_atiku 
WHERE EXISTS (
  SELECT 2 FROM presidential_aspirant_atiku paa  
  WHERE paa.Tweet_Id = presidential_aspirant_atiku.Tweet_Id AND paa.rowid < presidential_aspirant_atiku.rowid
);"""

SELECT Datetime, Tweet, Quoted_tweet_count, Reply_count, Retweet_count, Like_count
FROM presidential_aspirant_atiku paa
order by Like_count desc