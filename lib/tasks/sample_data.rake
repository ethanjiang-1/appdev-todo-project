# lib/tasks/sample_data.rake

require "faker"

desc "Fill the database with sample data (development only)"
task sample_data: :environment do
  unless Rails.env.development?
    puts "== This task only runs in development =="
    next
  end

  puts "== Clearing existing data =="
  Task.destroy_all
  GroupMembership.destroy_all
  Group.destroy_all
  User.destroy_all

  puts "== Creating users =="
  user_data = [
    { first_name: "Alice", last_name: "Example", email: "alice@example.com" },
    { first_name: "Bob", last_name: "Example", email: "bob@example.com" },
    { first_name: "Chris", last_name: "Example", email: "chris@example.com" },
    { first_name: "Dave", last_name: "Example", email: "dave@example.com" },
    { first_name: "Emma", last_name: "Example", email: "emma@example.com" },
    { first_name: "Frank", last_name: "Example", email: "frank@example.com" }
  ]
  users = user_data.map do |data|
    User.create!(
      first_name: data[:first_name],
      last_name: data[:last_name],
      email: data[:email],
      password: "password",
      password_confirmation: "password"
    )
  end
  puts "  → #{users.count} users created"

  puts "== Creating groups =="
  groups = 4.times.map do
    creator = users.sample
    group = Group.create!(
      name: Faker::Team.name,
      description: Faker::Lorem.sentence(word_count: 6),
      creator: creator
    )
    # add creator as admin
    GroupMembership.create!(user: creator, group: group, role: :admin)
    group
  end
  puts "  → #{groups.count} groups created"

  puts "== Adding members to groups =="
  groups.each do |group|
    # pick 2 random other users as members
    (users - [group.creator]).sample(2).each do |member|
      GroupMembership.create!(user: member, group: group, role: :member)
    end
  end

  puts "== Seeding tasks =="
  # personal tasks
  users.each do |user|
    2.times do
      Task.create!(
        title: Faker::Lorem.sentence(word_count: 3),
        notes: Faker::Lorem.paragraph(sentence_count: 2),
        due_date: Faker::Time.forward(days: 7, period: :day),
        creator: user,
        listable: user
      )
    end
  end

  # group tasks
  groups.each do |group|
    3.times do
      creator = group.users.sample
      Task.create!(
        title: Faker::Lorem.sentence(word_count: 3),
        notes: Faker::Lorem.paragraph(sentence_count: 2),
        due_date: Faker::Time.forward(days: 14, period: :day),
        creator: creator,
        listable: group
      )
    end
  end

  puts "== Done! =="
  puts "  Users:            #{User.count}"
  puts "  Groups:           #{Group.count}"
  puts "  Memberships:      #{GroupMembership.count}"
  puts "  Personal Tasks:   #{Task.where(listable_type: 'User').count}"
  puts "  Group Tasks:      #{Task.where(listable_type: 'Group').count}"
end
