require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    # ## DEBUG, WIP. ##
    # describe "as admin user" do
    #   let(:admin) { FactoryGirl.create(:admin) }
    #   before { sign_in admin }

    #   describe "should not be able to delete himself by submitting a DELETE request to the Users#destroy action" do
    #     specify do
    #       expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
    #     end
    #   end
    # end

    # describe "destroy" do
    #   let!(:admin) { FactoryGirl.create(:admin) }

    #   before do
    #     sign_in admin
    #   end

    #   it "should delete a normal user" do
    #     user = FactoryGirl.create(:user)
    #     expect { delete user_path(user), {},
    #       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
    #           #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
    #     to change(User, :count).by(-1)
    #   end

    #   it "should not allow the admin to delete herself" do
    #     expect { delete user_path(admin), {},
    #       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
    #           #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
    #     to_not change(User, :count)
    #   end
    # end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

        # ## DEBUG, WIP. ##
        # describe "destroy" do
        #   let!(:admin) { FactoryGirl.create(:admin) }

        #   before do
        #     sign_in admin
        #   end

        #   it "should delete a normal user" do
        #     user = FactoryGirl.create(:user)
        #     expect { delete user_path(user), {},
        #       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
        #       #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
        #     to change(User, :count).by(-1)
        #   end

        #   it "should not allow the admin to delete herself" do
        #     expect { delete user_path(admin), {},
        #       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
        #       #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
        #     to_not change(User, :count)
        #   end
        # end

        # describe "should NOT be able to delete an admin user" do
        #   let(:user) { FactoryGirl.create(:user) }

        # it "should not allow the admin to delete herself" do
        #   expect { delete user_path(admin), {},
        #     'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
        #     #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
        #   to_not change(User, :count)
        # end

        # it "should NOT be able to delete an admin user" do
        #   puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."

        #   delete user_path(user)
        #   expect { User.count }.to change(User, :count).by(-1)

        #   puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        # end

        # describe "can't delete self by submitting DELETE request to Users#destroy" do
        #   before { delete user_path(admin) }
        #   specify { response.should redirect_to(users_path), 
        #     flash[:error].should =~ /Can not delete own admin account!/i }
        # end
        
        # it "should not be able to delete itself" do
        #   expect { delete user_path(admin)  }.not_to change(User, :count) 
        # end

        # describe "deleting herself" do
        #   it "should not be possible" do
        #     expect { 
        #       puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."
        #       delete user_path(user) 
        #       puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
            
        #     }.to_not change(User, :count)
        #     puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        #   end
        # end

        # describe "should not be able to delete himself by submitting a DELETE request to the Users#destroy action" do
        #   specify do
        #     puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."
        #     expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
        #     puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        #   end
        # end

        # # specify do
        # #   expect { delete user_path(admin) }.to change(User, :count).by(0)
        # # end

        # describe "should be able to delete another user" do

        #   puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."

        #   before { delete user_path(user) }
        #   specify { expect { User.count }.to change(User, :count).by(-1) }

        #   puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        # end

        # it "should be able to delete another user" do

        #   puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."

        #   expect do
        #     before { delete user_path(user) }
        #     # click_link('delete', match: :first)
        #   end.to change(User, :count).by(-1)

        #   puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        # end

        # before { 
        #   puts "\nDEBUG, manual, '#{__FILE__}': user count, prior> '#{User.count}'."
        #   delete user_path(user) 
        #   puts "\nDEBUG, manual, '#{__FILE__}': user count> '#{User.count}'."
        # }

        
        # it { should }.change(User, :count).by(0) }
        # it "should NOT be able to delete an admin user" do
        #   expect { delete user_path(admin) }.to change(User, :count).by(0)
        # end

        # describe "should NOT be able to delete an admin user" do
        #   before { delete user_path(user) }
        #   specify { expect(response).to redirect_to(root_url) }
        # end

        # it "should NOT be able to delete an admin user" do

        #   expect do
        #     delete user_path(admin)
        #     # click_link('delete', match: :first)
        #   end.to change(User, :count).by(0)

        # end

      end
    end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }

        it { should have_content("Name can't be blank") }
        it { should have_content('The form contains 5 errors.') }
        it { should have_content("Email can't be blank") }
        it { should have_content("Email is invalid") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Password is too short (minimum is 6 characters)") }

      end

    end

    describe "with valid information" do

      let(:user) { FactoryGirl.build(:user) }
      before { valid_signup(user) }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end

  end
end

