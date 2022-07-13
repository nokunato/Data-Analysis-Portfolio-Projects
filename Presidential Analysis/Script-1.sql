--Tinubu Query
DELETE FROM presidential_aspirant_tinubu 
WHERE EXISTS (
  SELECT 2 FROM presidential_aspirant_tinubu pat  
  WHERE pat.Tweet_Id = presidential_aspirant_tinubu.Tweet_Id AND pat.rowid < presidential_aspirant_tinubu.rowid
);

SELECT Datetime, Tweet, Quoted_tweet_count, Reply_count, Retweet_count, Like_count
from presidential_aspirant_tinubu
order by Like_count desc