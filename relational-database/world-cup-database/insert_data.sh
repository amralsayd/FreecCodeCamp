#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    echo "Inserted into games, $YEAR : $ROUND : $WINNER_GOALS : $OPPONENT_GOALS : $WINNER : $OPPONENT"
    # get major_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert major
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_WINNER_RESULT
      # if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      # then
      #   echo Inserted into teams winner, $WINNER
      # fi

      # get new major_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi


    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert major
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT_RESULT
      # if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      # then
      #   echo Inserted into teams opponent, $OPPONENT
      # fi

      # get new major_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert into majors_courses
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")
    # if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    # then
    #   echo "Inserted into games, $YEAR : $ROUND : $WINNER_GOALS : $OPPONENT_GOALS : $WINNER_ID : $OPPONENT_ID"
    # fi

  fi
done
