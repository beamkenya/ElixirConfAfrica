# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElixirConfAfrica.Repo.insert!(%ElixirConfAfrica.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ElixirConfAfrica.Repo
alias ElixirConfAfrica.Events.Event

datetime = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

%Event{
  name: "ElixirConf 2024",
  event_type: "Conference",
  location: "Nairobi",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "BEAM: The Perfect Fit for Networks",
  event_type: "Webinar",
  location: "Zoom",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "Learn You Some Erlang",
  event_type: "Webinar",
  location: "Somewhere Crazy",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "Who Supervises The Supervisor",
  event_type: "Webinar",
  location: "Who Knows?",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()
