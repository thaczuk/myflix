# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Category.create(name: "Comedies")
dramas = Category.create(name: "Dramas")

Video.create(title: "South Park1",
                    description: "Kill Kenny",
                    small_cover_url: "tmp/south_park.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)

Video.create(title: "South Park2",
                    description: "Kill Kenny",
                    small_cover_url: "tmp/south_park.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)

Video.create(title: "South Park3",
                    description: "Kill Kenny",
                    small_cover_url: "tmp/south_park.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)

Video.create(title: "Family Guy1",
                    description: "Family guy",
                    small_cover_url: "tmp/futurama.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)
Video.create(title: "Family Guy2",
                    description: "Family guy",
                    small_cover_url: "tmp/futurama.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)
Video.create(title: "Family Guy3",
                    description: "Family guy",
                    small_cover_url: "tmp/futurama.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)
Video.create(title: "Family Guy4",
                    description: "Family guy",
                    small_cover_url: "tmp/futurama.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: comedies)

Video.create(title: "Monk",
                    description: "paranoid detective",
                    small_cover_url: "tmp/monk.jpg",
                    large_cover_url: "tmp/monk_large.jpg", category: dramas)