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
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "BEAM: The Perfect Fit for Networks",
  event_type: "Webinar",
  location: "Zoom",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "Learn You Some Erlang",
  event_type: "Webinar",
  location: "Somewhere Crazy",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()

%Event{
  name: "Who Supervises The Supervisor",
  event_type: "Webinar",
  location: "Who Knows?",
  start_date: datetime,
  end_date: NaiveDateTime.add(datetime, Enum.random(1..5), :day)
}
|> Repo.insert!()
