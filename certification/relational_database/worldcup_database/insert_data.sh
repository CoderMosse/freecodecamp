#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
GET_TEAM_ID() {
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1';")
  echo $TEAM_ID
}

INSERT_TEAM() {
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1');")
}

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then    
    WINNER_ID=$(GET_TEAM_ID "$WINNER")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM "$WINNER"
      WINNER_ID=$(GET_TEAM_ID "$WINNER")    
    fi
      
    OPPONENT_ID=$(GET_TEAM_ID "$OPPONENT")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM "$OPPONENT"
      OPPONENT_ID=$(GET_TEAM_ID "$OPPONENT")
    fi

    _=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  fi
done