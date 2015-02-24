require 'spec_helper'

describe ForgotPasswordsController do
  context 'with blank input' do
    before { post :create, email: '' }

    it 'redirects to the forgot password page' do
      expect(response).to redirect_to forgot_password_path
    end

    it 'shows an error message' do
      expect(flash[:error]).to eq('Email cannot be blank.')
    end
  end

  context 'with existing email' do
    before {
      Fabricate(:user, email: 'joe@example.com')
      post :create, email: 'joe@example.com'
    }

    it 'redirects to the forgot password confirmation page' do
      expect(response).to redirect_to forgot_password_confirmation_path
    end

    it 'send out an email to the email address' do
      expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
    end
  end

  context 'with non-existing email' do
    before {
      post :create, email: 'foo@example.com'
    }

    it 'redirects to the forgot password page' do
      expect(response).to redirect_to forgot_password_path
    end

    it 'shows an error message' do
      expect(flash[:error]).to eq('There is no user with that email in the system.')
    end
  end
end