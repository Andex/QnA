admin = User.create!(email: 'admin@admin.ru',
                     password: '121212',
                     confirmed_at: Time.now,
                     admin: true)

users = []
users << User.create(email: 'user1@test.com',
                     password: 'qweqwe',
                     confirmed_at: Time.now)
users << User.create(email: 'user2@test.com',
                     password: 'qweqwe',
                     confirmed_at: Time.now)
4.times do
  users << User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 8),
    confirmed_at: Time.now
  )
end

questions = []
questions << Question.create([
             { title: 'What movie / book is this phrase from? ', body: Faker::Books::Dune.quote, user: users.sample },
             { title: 'What movie / book is this phrase from? ', body: Faker::Movies::BackToTheFuture.quote, user: users.sample },
             { title: 'Back to the Future films', body: 'What dates did Doc and Marty travel on in the Back to the Future films?', user: users.sample },
             { title: 'Error occurred while installing mini_racer',
               body: 'Gem::Ext::BuildError: ERROR: Failed to build gem native extension\\nPlease help with the solution',
               user: users.sample },
])
questions.flatten!

# Create rewards for few questions
rewards = %w[spec/files/reward.png spec/files/reward_2.jpeg spec/files/reward_3.jpg]

6.times do
  reward = Reward.create(title: Faker::Quotes::Chiquito.term)
  reward.image.attach(io: File.open(rewards.sample), filename: 'reward from question')
  reward.question = questions.flatten.sample
  reward.save!
end

answers = []
3.times do
  answers << Answer.create([
             { body: Faker::Book.title, question: Question.first, user: users.sample },
             { body: Faker::Movie.title, question: Question.second, user: users.sample },
             { body: Faker::Movies::BackToTheFuture.date, question: Question.third, user: users.sample },
             { body: Faker::Hacker.say_something_smart, question: Question.last, user: users.sample }
  ])
end
answers.flatten!

# Create few comments for questions and answers
questions.each do |question|
  # Set a random answer to the best
  question.answers.sample.mark_as_best

  rand(1..3).times do
    question.comments.create(
      body: Faker::Quote.famous_last_words,
      user: users.sample
    )
  end
  rand(2..5).times do
    question.answers.sample.comments.create(
      body: Faker::Quote.famous_last_words,
      user: users.sample
    )
  end
end

10.times do
  questions.sample.files.attach(io: File.open(rewards.sample), filename: 'file for question')
  answers.sample.files.attach(io: File.open(rewards.sample), filename: 'file for answer')
end

# Create links for questions
8.times do
  subject = Faker::Verb.base
  questions.sample.links.create(
    name: subject,
    url: "https://yandex.ru/images/search?utm_source=main_stripe_big&text=#{subject}"
  )
  questions.sample.links.create(
    name: 'gist link',
    url: 'https://gist.github.com/Andex/7f12685131f53e148d71a5d5ac4495f3'
  )
end

# Create links for answers
10.times do
  subject = Faker::Verb.base
  answers.sample.links.create(
    name: "link to picture #{subject}",
    url: "https://yandex.ru/images/search?utm_source=main_stripe_big&text=#{subject}"
  )
  answers.sample.links.create(
    name: 'gist link',
    url: 'https://gist.github.com/Andex/7f12685131f53e148d71a5d5ac4495f3'
  )
end

# Simulate rating for questions
10.times do
  questions.sample.vote(1, users.sample)
  questions.sample.vote(-1, users.sample)
end

# Simulate rating for answers
10.times do
  answers.sample.vote(1, users.sample)
  answers.sample.vote(-1, users.sample)
end
