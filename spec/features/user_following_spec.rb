require 'spec_helper'

feature 'user following' do
  scenario 'user follows and unfollows someone' do
    alice = Fabricate(:user)
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    Fabricate(:review, user: alice, video: monk)

    sign_in
    click_on_video_on_home_page(monk)

    click_link alice.full_name
    click_link 'Follow'
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end