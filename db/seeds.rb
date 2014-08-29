# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Category.create(name: "Comedies")
dramas = Category.create(name: "Dramas")

Video.create(title: "Futurama", description: "Space Travel!", category: comedies, small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Monk", description: "Paranoid SF detective", category: dramas, small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "South Park", description: "Crazy Kids!", category: dramas, small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Family Guy", description: "Talking dog", category: comedies, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Futurama", description: "Space Travel!", category: comedies, small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Monk", description: "Paranoid SF detective", category: dramas, small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "South Park", description: "Crazy Kids!", category: dramas, small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Family Guy", description: "Talking dog", category: comedies, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Family Guy", description: "Talking dog", category: comedies, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Family Guy", description: "Talking dog", category: comedies, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
