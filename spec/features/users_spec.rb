require 'spec_helper'

feature 'User signup' do
  let(:user) { build(:user) }

  def fill_fields(*except_keys)
    keys = %i(firstname lastname email password password_confirmation)
    (keys - except_keys).each do |key|
      field_name = key.to_s.capitalize.gsub('_', ' ')
      fill_in field_name, with: user.send(key)
    end
  end

  context 'when valid' do
    before :each do
      visit signup_path
      fill_fields
      click_button 'Create'
    end

    it 'redirects to index page' do
      expect(page.current_path).to eq(root_path)
      expect(page.status_code).to eq(200)
    end

    it 'shows success message' do
      expect(page).to have_content(/successfully created/i)
    end
  end

  context 'when not valid' do
    before :each do
      visit signup_path
      fill_fields(:password_confirmation)
      click_button 'Create'
    end

    it 'renders new user page' do
      expect(page.current_path).to eq(create_user_path)
    end

    it 'shows errors' do
      expect(page).to have_content(/invalid/i)
      expect(page).to have_content(/password/i)
    end

    it 'leaves filled fields' do
      %i(firstname lastname email).each do |key|
        field_name = key.to_s.capitalize
        expect(find_field(field_name).value).to eq(user[key])
      end
    end
  end
end
