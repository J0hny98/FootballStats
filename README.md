# Football stats

## Prerequisities

### PostgreSQL

Before you run the application you need to have running PostgreSQL databse on port `5432` with the correct database schema. [Create script](./resources/Database.sql) for this schema is in the resources folder as `Database.sql`. You just need to create the database and then execute this script. You can take a look on a [database schema](./resources/Database.pdf) which is also in the resources foled as `Database.pdf`.

Also you have to provide correct credentials for the created database. These credentials need to be inserted into the [config file](./lib/config.rb) which is in the lib folder as `config.rb`. Right now there are dummy values.

* DATABASE_NAME - Name of the created database
    * Current value - football_stats
* DATABASE_USER - Username of the user who can read/write data from/to the database
    * Current value - admin
* DATABASE_PASSWORD - Password of the user who can read/write data from/to the database
    * Current value - admin

### Football-data API key

Application needs an API key for the [football-data](https://www.football-data.org/) API so it can download football stats data. To obtain this API key, you have to create a registration on their website https://www.football-data.org. Don't worry this registration if free for the lowest tier.

Once you obtain this API key, you have to insert it into the [config file](./lib/config.rb) which is in the lib folder as `config.rb`. Right now there is a dummy value as API_KEY field with value `api-key`.

## Instalation and run

Application is written as a gem. First of all you have to build the gem using this command: `gem build football_stats.gemspec`. Then you have to install the gem using this command: `gem install football_stats-0.1.0.gem`.

After this you should be able to run the application using the file in the bin folder - [football_stats](./bin/football_stats). If you run it without any arguments, you will see the help page written in the console.

Other way to use the application is to use it directly in your ruby script using the `require football_stats` in the beginning of your script.

## Tests

To run the tests execute this command `rake test`.

## Example of running the application

You can run the application by executing this file [football_stats](./bin/football_stats) in the bin folder like this `./football_stats <COMMAND> <ARGUMENTS>`.

Example of executing the file without any command arguments.

```bash
$ ./football_stats
Commands:
  football_stats clean_update                                              # Removes all the data from the database and then inserts the clean loaded data from the API.
  football_stats help [COMMAND]                                            # Describe available commands or one specific command
  football_stats insert_competitions                                       # Inserts all available competitions loaded from the API, then prints and returns them.
  football_stats insert_teams [CLEAN_INSERT]                               # Inserts all the teams and their matches for the existing competitions, then returns and prints the teams. If the...
  football_stats remove_all_data                                           # Removes all the data from the database.
  football_stats remove_all_teams                                          # Removes all the teams data from the database.
  football_stats select_all_competitions                                   # Prints and returns all competitions from the database.
  football_stats select_all_teams                                          # Prints and returns all teams from the database.
  football_stats select_competition_by_code [CODE]                         # Prints and returns competition with the provided [CODE] if exists.
  football_stats select_competition_by_id [ID]                             # Prints and returns competition with the provided [ID] if exists.
  football_stats select_competition_by_name [NAME]                         # Prints and returns competition with the provided [NAME] if exists.
  football_stats select_matches_for_team_with_id [TEAM_ID]                 # Prints and returns all matches for team with the provided [TEAM_ID] if exists.
  football_stats select_matches_for_team_with_name [TEAM_NAME]             # Prints and returns all matches for team with the provided [TEAM_NAME] if exists.
  football_stats select_team_by_id [ID]                                    # Prints and returns team with the provided [ID] if exists.
  football_stats select_team_by_name [NAME]                                # Prints and returns team with the provided [NAME] if exists.
  football_stats select_teams_in_competition_with_id [COMPETITION_ID]      # Prints and returns all the teams playing the competition with the provided [COMPETITION_ID] if exists.
  football_stats select_teams_in_competition_with_name [COMPETITION_NAME]  # Prints and returns all the teams playing the competition with the provided [COMPETITION_NAME] if exists.
  football_stats update_matches_for_team_with_id [TEAM_ID]                 # Updates matches for team with the provided [TEAM_ID].
  football_stats update_matches_for_team_with_name [TEAM_NAME]             # Updates matches for team with the provided [TEAM_NAME].
```

## Known issues

### Installing pg gem on Ubuntu

When installing the needed pg gem on Ubuntu there might be an issue with missing `libpq-dev` library. To resolve this issue you have to install it manualy. Here is a description how to do it on Ubuntu 22.04.

Run `sudo apt-get install libpq5=14.5-0ubuntu0.22.04.1` and then run `sudo apt-get install libpq-dev`.

After this you should be able to install the pg gem.

## Features

Assuming running the [football_stats](./bin/football_stats) file from the bin folder.

### Help

Describe available commands or one specific command

Usage: `./football_stats help [COMMAND]`

To print help for all the commands leave the `[COMMAND]` blank, i.e. `./football_stats`

### Clean update

Removes all the data from the database and then inserts the clean loaded data from the API.

Usage: `./football_stats clean_update`

### Insert competitions

Inserts all available competitions loaded from the API, then prints and returns them.

Usage: `./football_stats insert_competitions`

Returns `nil`.

### Insert teams

Inserts all the teams and their matches for the existing competitions, then returns and prints the teams. If the [CLEAN_INSERT] is true, then it first removes the teams and their matches from the database.

Usage: `./football_stats insert_teams [CLEAN_INSERT]`, i.e. `./football_stats insert_teams true`

Returns `array` which contains [Team objects](./lib/football_stats/entity/team.rb).

### Remove all data

Removes all the data from the database.

Usage: `./football_stats remove_all_data`
  
Returns `nil`.

### Remove all teams

Removes all the teams data from the database.

Usage: `./football_stats remove_all_teams`

Returns `nil`.

### Select all competitions

Prints and returns all competitions from the database.

Usage: `./football_stats select_all_competitions`

Returns `array` which contains [Competition objects](./lib/football_stats/entity/competition.rb).

### Select all teams

Prints and returns all teams from the database.

Usage: `./football_stats select_all_teams`

Returns `array` which contains [Team objects](./lib/football_stats/entity/team.rb).

### Select competition by code

Prints and returns competition with the provided code if exists.

Usage: `./football_stats select_competition_by_code [CODE]`, i.e. `./football_stats select_competition_by_code PL`

Returns found competition as [Competition object](./lib/football_stats/entity/competition.rb) or `nil` if competition is not found.

### Select competition by id

Prints and returns competition with the provided id if exists.

Usage: `./football_stats select_competition_by_id [ID]`, i.e. `./football_stats select_competition_by_id 2021`

Returns found competition as [Competition object](./lib/football_stats/entity/competition.rb) or `nil` if competition is not found.

### Select competition by name

Prints and returns competition with the provided name if exists.

Usage: `./football_stats select_competition_by_name [NAME]`, i.e. `./football_stats select_competition_by_name "Premier League"`

Returns found competition as [Competition object](./lib/football_stats/entity/competition.rb) or `nil` if competition is not found.

### Select macthes for team with id

Prints and returns all matches for team with the provided id if exists.

Usage: `./football_stats select_matches_for_team_with_id [TEAM_ID]`, i.e. `./football_stats select_matches_for_team_with_id 61`

Returns `array` which contains [Match objects](./lib/football_stats/entity/match.rb).

### Select macthes for team with name

Prints and returns all matches for team with the provided name if exists.

Usage: `./football_stats select_matches_for_team_with_name [TEAM_NAME]`, i.e. `./football_stats select_matches_for_team_with_name "Chelsea FC"`

Returns `array` which contains [Match objects](./lib/football_stats/entity/match.rb).

### Select team by id

Prints and returns team with the provided id if exists.

Usage: `./football_stats select_team_by_id [ID]`, i.e. `./football_stats select_team_by_id 61`

Returns found team as [Team object](./lib/football_stats/entity/team.rb) or `nil` if team is not found.

### Select team by name

Prints and returns team with the provided name if exists.

Usage: `./football_stats select_team_by_name [NAME]`, i.e. `./football_stats select_team_by_name "Chelsea FC"`

Returns found team as [Team object](./lib/football_stats/entity/team.rb) or `nil` if team is not found.

### Select teams in competition with id

Prints and returns all the teams playing the competition with the provided id if exists.

Usage: `./football_stats select_teams_in_competition_with_id [COMPETITION_ID]`, i.e. `./football_stats select_teams_in_competition_with_id 2021`

### Select teams in competition with name

Prints and returns all the teams playing the competition with the provided name if exists.

Usage: `./football_stats select_teams_in_competition_with_name [COMPETITION_NAME]`, i.e. `./football_stats select_teams_in_competition_with_name "Premier League"`

Returns `array` which contains [Team objects](./lib/football_stats/entity/team.rb).

### Update matches for team with id

Updates matches for team with the provided id.

Usage: `./football_stats update_matches_for_team_with_id [TEAM_ID]`, i.e. `./football_stats update_matches_for_team_with_id 61`

Returns `nil`.

### Update matches for team with name

Updates matches for team with the provided name.

Usage: `./football_stats update_matches_for_team_with_name [TEAM_NAME]`, i.e. `./football_stats update_matches_for_team_with_name "Chelsea FC"`

Returns `nil`.