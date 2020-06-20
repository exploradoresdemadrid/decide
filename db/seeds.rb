# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Rails.env.development?
  raise 'Running seeds in non-development environment'
end

Voting.destroy_all
Group.destroy_all
User.destroy_all

%i[admin superadmin].each do |role|
  User.find_or_create_by!(email: "#{role}@example.com") do |user|
    user.password = '12345678'
    user.role = role
  end
end

MAX_VOTES = 6

groups = [
  ['ÁLAMOS', 260],
  ['ALBORADA', 434],
  ['ALCORES', 404],
  ['ALFA CENTAURO', 291],
  ['ALONDRA', 224],
  ['ALTAHAY', 356],
  ['ALTOS PIRINEOS', 101],
  ['ANNAPURNA', 959],
  ['ANTÁRTIDA', 621],
  ['AZIMUT', 608],
  ['BETELGEUSE', 566],
  ['BOANERJES', 618],
  ['BUEN CONSEJO', 95],
  ['CARRICK', 579],
  ['CARTAGO', 476],
  ['CUERDA LARGA', 655],
  ['ESPISAR', 652],
  ['ESTRELLA POLAR', 191],
  ['EVEREST', 194],
  ['FÉNIX', 665],
  ['GAIA', 458],
  ['HEPTÁGONO', 668],
  ['HESPERIA', 456],
  ['III DE EXPLORADORES DE MADRID', 3],
  ['IMPEESA', 682],
  ['INDIANAS', 521],
  ['ÍTACA', 651],
  ['JARAHONDA', 666],
  ['JARAMA', 667],
  ['KENYA', 225],
  ['KIMBALL', 110],
  ['KOLONIA DE B.P', 347],
  ['LA MERCED', 147],
  ['LA SALLE', 85],
  ['LUJÁN', 102],
  ['MONTEPERDIDO', 960],
  ['NURIA', 669],
  ['ORION – B', 962],
  ['PAZ', 961],
  ['PHOENIX', 701],
  ['PINAR', 708],
  ['PIRINEOS', 440],
  ['PLANETA', 654],
  ['PLÉYADES', 569],
  ['PROEL', 334],
  ['QUERCUS', 610],
  ['REINA DEL CIELO', 284],
  ['ROQUENUBLO', 620],
  ['SAN AGUSTÍN', 151],
  ['SAN AGUSTÍN LOS NEGRALES', 705],
  ['SANTIAGO APÓSTOL', 457],
  ['SANTIAGO EL MAYOR', 1],
  ['TIERRA DEL FUEGO', 362],
  ['TROTAMUNDOS', 697],
  ['WANCHE', 425]
].map do |(name, number)|
  Group.find_or_create_by!(number: number) do |group|
    group.name = name.downcase.capitalize
    group.available_votes = 1 + rand(MAX_VOTES - 1)
  end
end

public_voting = Voting.find_or_create_by!(title: 'Weather voting') do |voting|
  voting.description = 'This is not a secret voting'
  voting.secret = false
end

public_voting.open!

public_voting.questions.find_or_create_by!(title: 'What color is the sky?') do |question|
  question.options.find_or_initialize_by(title: 'Blue')
  question.options.find_or_initialize_by(title: 'Red')
  question.options.find_or_initialize_by(title: 'Green')
end

public_voting.questions.find_or_create_by!(title: 'How is the temperature?') do |question|
  question.options.find_or_initialize_by(title: 'Freezing cold')
  question.options.find_or_initialize_by(title: 'Not bad')
  question.options.find_or_initialize_by(title: 'Really hot')
  question.options.find_or_initialize_by(title: 'Are we in hell?')
end

groups.each do |group|
  response = public_voting.questions.map do |question|
    [
      question.id,
      group.available_votes.times.map { question.option_ids.sample }.group_by(&:itself).transform_values(&:count)
    ]
  end.to_h

  VoteSubmissionService.new(group, public_voting, response).vote!
  puts "[GS #{group.id}] Vote submitted"
end

public_voting.finished!
