require 'rails_helper'

describe My::ProfileController do
  describe 'GET show' do
    describe 'ensure user is logged in' do
      before :each do
        get :show, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate.build(:user, id: 123)
        login_user
        get :show
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET edit' do
    describe 'ensure user is logged in' do
      before :each do
        get :edit, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      let(:link_count) { 0 }
      let(:links)      { build_array(link_count, :link) }

      before :each do
        @user = Fabricate.build(:user, id: 123, links: links)
        login_user
        get :edit
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      context 'when the user has not got any links yet' do
        let(:link_count) { 0 }

        it 'builds a new link' do
          expect(@user.links.length).to eql(link_count + 1)
          expect(@user.links.last).to be_new_record
        end
      end

      context 'when the user has links already' do
        let(:link_count) { 2 }

        it 'does not build a new link' do
          expect(@user.links.length).to eql(link_count)
        end
      end

      it 'assigns a new TempImage for the file uploader' do
        expect(assigns[:temp_image]).to be_new_record
        expect(assigns[:temp_image]).to be_a(TempImage)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT update' do
    describe 'ensure user is logged in' do
      before :each do
        put :update, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      let(:link_count)      { 0 }
      let(:links)           { build_array(link_count, :link) }
      let(:updated)         { true }
      let(:image_processed) { true }
      let(:user_params)     { {first_name: 'Mary'} }
      let(:update_result)   { true }

      before :each do
        @user = Fabricate.build(:user, id: 123, links: links)
        login_user
        allow(controller).to receive(:update_and_process_image).and_return(update_result)
        put :update, user: user_params
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'updates and processes the image for the user' do
        expect(controller).to have_received(:update_and_process_image).with(@user, user_params)
      end

      context 'when successfully updated' do
        let(:update_result) { true }

        it 'redirects to the show page' do
          expect(response).to redirect_to(my_profile_path)
        end

        it 'shows a success notice' do
          expect(flash[:notice]).to eql('Successfully changed your details.')
        end
      end

      context 'when not successfully updated' do
        let(:update_result) { false }

        context 'when the user has not got any links yet' do
          let(:link_count) { 0 }

          it 'builds a new link' do
            expect(@user.links.length).to eql(link_count + 1)
            expect(@user.links.last).to be_new_record
          end
        end

        context 'when the user has links already' do
          let(:link_count) { 2 }

          it 'does not build a new link' do
            expect(@user.links.length).to eql(link_count)
          end
        end

        it 'assigns a new TempImage for the file uploader' do
          expect(assigns[:temp_image]).to be_new_record
          expect(assigns[:temp_image]).to be_a(TempImage)
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'ensure user is logged in' do
      before :each do
        delete :destroy, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate.build(:user, id: 123)
        login_user
        allow(@user).to receive(:mark_deleted!)
        delete :destroy
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'marks the current user as deleted' do
        expect(@user).to have_received(:mark_deleted!).with(@user)
      end

      it 'redirects to the root page' do
        expect(response).to redirect_to(:root)
      end

      it 'displays a flash message' do
        expect(flash[:notice]).to eql('Your account has now been deleted.')
      end
    end
  end
end

