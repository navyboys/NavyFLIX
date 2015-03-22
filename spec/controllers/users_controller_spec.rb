require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create", sidekiq: :inline do
    context "successful user sign in page" do
      it "redirects to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'failed user sign up' do
      let(:result) { double(:sign_up_result, successful?: false, error_message: 'Your card is declined.') }

      before {
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripe_token: '1231241'
      }

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Your card is declined.')
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 3}
    end

    it 'sets @user' do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe 'GET new_with_invitation_token' do
    context 'with valid token' do

      let(:invitation) { Fabricate(:invitation) }
      before {
        get :new_with_invitation_token, token: invitation.token
      }

      it 'renders the :new view tempate' do
        expect(response).to render_template :new
      end

      it "sets @user with recipient's email" do
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it 'sets @invitation_token' do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end

    it 'redirects to expired token page for invilid tokens' do
      get :new_with_invitation_token, token: 'abcdef'
      expect(response).to redirect_to expired_token_path
    end
  end
end