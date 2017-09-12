require 'httparty'

def player_seed(offset)
    url = "http://api.fantasy.nfl.com/v1/players/editordraftranks?count=100&format=json&offset=#{offset}"
    response = HTTParty.get(url)
    players_hash = response.parsed_response
    players_hash = players_hash["players"]

    players_hash.map do |player|
      if player["position"] == "QB" || player["position"] == "RB" || player["position"] == "WR" || player["position"] == "TE" || player["position"] == "DEF" || player["position"] == "K"

        Player.create(first_name: player["firstName"],
          last_name: player["lastName"],
          player_id: player["id"],
          teamAbbr: player["teamAbbr"],
          rank: player["rank"],
          position: player["position"]
          )
      end
    end
end

#API only limits request to 100 players. Must Call multiply times to get all players
def seed_db
player_seed(0)
player_seed(100)
player_seed(200)
player_seed(300)
player_seed(400)
player_seed(500)
end
seed_db

def add_projected_stats
  url = "http://api.fantasy.nfl.com/v1/players/stats?statType=seasonProjectedStats&season=2017"

  response = HTTParty.get(url)
  projected_hash = response.parsed_response
  projected_hash = projected_hash["players"]

  projected_hash.map do |projected|
    if Player.find_by(player_id: projected["id"])
       player = Player.find_by(player_id: projected["id"])
       player.update(projected_points: projected["seasonProjectedPts"])
    end
  end
end
add_projected_stats
