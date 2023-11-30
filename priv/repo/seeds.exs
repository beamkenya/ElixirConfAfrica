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

alias ElixirConfAfrica.Events.Event
alias ElixirConfAfrica.Repo
alias ElixirConfAfrica.TicketTypes.TicketType

ticket_types_names = ["Early Bird", "Regular", "VIP/All Access", "Student"]

# Random seed
Enum.each(1..10, fn _num ->
  datetime = Faker.DateTime.forward(Enum.random(1..30))

  event =
    Repo.insert!(%Event{
      name: Faker.Lorem.sentence(),
      event_type: Faker.Lorem.sentence(1),
      location: Faker.Address.En.street_address(),
      description: Faker.Lorem.paragraph(),
      start_date: NaiveDateTime.truncate(datetime, :second),
      end_date:
        datetime
        |> NaiveDateTime.truncate(:second)
        |> NaiveDateTime.add(Enum.random(1..5), :day)
    })

  Enum.each(Enum.shuffle(ticket_types_names), fn type ->
    Repo.insert!(%TicketType{
      event_id: event.id,
      name: type,
      description: Faker.Lorem.sentence(),
      price: 0.0 + Enum.random(20..500),
      number: Enum.random(100..500)
    })
  end)
end)

# Almost random seed
datetime = Faker.DateTime.forward(Enum.random(1..30))

event =
  Repo.insert!(%Event{
    name: "ElixirConf 2024",
    event_type: "Conference",
    location: "Nairobi",
    description: "A very long and BEAMy description of some interestingly scary concept",
    start_date: NaiveDateTime.truncate(datetime, :second),
    end_date: datetime |> NaiveDateTime.truncate(:second) |> NaiveDateTime.add(Enum.random(1..5), :day)
  })

Enum.each(Enum.shuffle(ticket_types_names), fn type ->
  Repo.insert!(%TicketType{
    event_id: event.id,
    name: type,
    description: Faker.Lorem.sentence(),
    price: 0.0 + Enum.random(20..500),
    number: Enum.random(100..500)
  })
end)

datetime = Faker.DateTime.forward(Enum.random(1..30))

Repo.insert!(%Event{
  name: "BEAM: The Perfect Fit for Networks",
  event_type: "Webinar",
  location: "Zoom",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: NaiveDateTime.truncate(datetime, :second),
  end_date: datetime |> NaiveDateTime.truncate(:second) |> NaiveDateTime.add(Enum.random(1..5), :day)
})

Enum.each(Enum.shuffle(ticket_types_names), fn type ->
  Repo.insert!(%TicketType{
    event_id: event.id,
    name: type,
    description: Faker.Lorem.sentence(),
    price: 0.0 + Enum.random(20..500),
    number: Enum.random(100..500)
  })
end)

datetime = Faker.DateTime.forward(Enum.random(1..30))

Repo.insert!(%Event{
  name: "Learn You Some Erlang",
  event_type: "Webinar",
  location: "Somewhere Crazy",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: NaiveDateTime.truncate(datetime, :second),
  end_date: datetime |> NaiveDateTime.truncate(:second) |> NaiveDateTime.add(Enum.random(1..5), :day)
})

Enum.each(Enum.shuffle(ticket_types_names), fn type ->
  Repo.insert!(%TicketType{
    event_id: event.id,
    name: type,
    description: Faker.Lorem.sentence(),
    price: 0.0 + Enum.random(20..500),
    number: Enum.random(100..500)
  })
end)

datetime = Faker.DateTime.forward(Enum.random(1..30))

Repo.insert!(%Event{
  name: "Who Supervises The Supervisor",
  event_type: "Webinar",
  location: "Who Knows?",
  description: "A very long and BEAMy description of some interestingly scary concept",
  start_date: NaiveDateTime.truncate(datetime, :second),
  end_date: datetime |> NaiveDateTime.truncate(:second) |> NaiveDateTime.add(Enum.random(1..5), :day)
})

Enum.each(Enum.shuffle(ticket_types_names), fn type ->
  Repo.insert!(%TicketType{
    event_id: event.id,
    name: type,
    description: Faker.Lorem.sentence(),
    price: 0.0 + Enum.random(20..500),
    number: Enum.random(100..500)
  })
end)
