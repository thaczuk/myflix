Fabricator (:review) do
  rating    { rand (1..5) }
  video_id {Random.rand(2)}
  user_id  {Random.rand(2)}
  body  { Faker::Lorem.paragraph(3) }
  video {}
  user   {}
end