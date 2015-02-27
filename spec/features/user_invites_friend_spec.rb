require 'spec_helper'

feature 'user invites friend' do
  scenario 'user successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend
    friend_accepte_invitation
    friend_signs_in

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: 'John Doe'
    fill_in "Friend's Email Address", with: 'john@example.com'
    fill_in 'Message', with: 'Hello please join this site.'
    click_button 'Send Invitation'
    sign_out
  end

  def friend_accepte_invitation
    open_email 'john@example.com'
    current_email.click_link 'Accept this invitation'
    fill_in 'Password', with: 'password'
    fill_in 'Full name', with: 'John Doe'
    click_button 'Sign Up'
  end

  def friend_signs_in
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
  end

  def friend_should_follow(user)
    click_link 'People'
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link 'People'
    expect(page).to have_content 'John Doe'
  end
end
