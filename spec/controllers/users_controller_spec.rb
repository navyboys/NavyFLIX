require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create", sidekiq: :inline do
    context "with valid personal & card info" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

    end

    context "with valid personal & card info and by invitation" do
      let(:alice) { Fabricate(:user) }
      let(:joe) { User.where(email: 'joe@example.com').first }
      let(:charge) { double(:charge, successful?: true) }

      before {        
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token
      }

      it 'makes the user follow the inviter' do
        expect(joe.follows?(alice)).to be_truthy
      end

      it 'makes the inviter follow the user' do
        expect(alice.follows?(joe)).to be_truthy
      end

      it 'expires the invitation upon acceptance' do
        expect(Invitation.first.token).to be_nil
      end
    end

    context 'valid personal info and declined card' do
      let(:charge) { double(:charge, successful?: false, error_message: 'Your card is declined.') }

      before {
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripe_token: '1231241'
      }

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'does not create a new record' do
        expect(User.count).to eq(0)
      end

      it 'sets the flash error message' do
        expect(flash{:error}).to be_present
      end
    end

    context "with invalid personal info" do
      it "does not create the user" do
        post :create, user: { password: "password" }
        expect(User.count).to eq(0)
      end

      it "render the :new template" do
        post :create, user: { password: "password" }
        expect(response).to render_template :new
      end
      
      it "sets @user" do
        post :create, user: { password: "password" }
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'does not charge the card' do
        StripeWrapper::Charge.should_not_receive(:create)        
        post :create, user: { password: "password" }
      end

      it 'does not send out email with invalid inouts' do
        post :create, user: { email: 'joe@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'sending emails' do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }

      it 'sends out email to the user with valid inputs' do
        post :create, user: { email: 'joe@example.com', password: "password", full_name: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end 

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: "password", full_name: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
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