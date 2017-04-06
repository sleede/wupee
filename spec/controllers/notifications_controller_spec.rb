require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:notification) { create :notification }

  before :each do
    allow_any_instance_of(NotificationsController).to receive(:current_user).and_return(notification.receiver)
  end

  it 'should get current user' do
    expect(subject).to receive(:current_user).and_return(notification.receiver)
    get :index, format: :json
  end

  describe 'GET index json' do
    render_views

    it "should returns a notification from a rendered template" do
      get :index, format: :json
      expect(json.size).to eq 1
      expect(json[0]['id']).to eq notification.id
      expect(json[0]['message']['subject']).to eq "subject"
    end

    it "should accept scopes as param" do
      get :index, format: :json, scopes: "unwanted"
      expect(json.size).to eq 0  
    end
  end

  describe 'GET show json' do
    render_views

    it "should returns a notification from a rendered template" do
      get :show, format: :json, id: notification.id
      expect(json['id']).to eq notification.id
      expect(json['message']['subject']).to eq "subject"
    end
  end

  describe 'PUT update' do
    render_views

    it "should mark as read" do
      patch :mark_as_read, id: notification.id, format: :json
      expect(json['is_read']).to eq true
    end
  end

  describe 'PUT update_all' do
    render_views

    it "should all notification of user mark as read" do
      patch :mark_all_as_read, format: :json
      expect(notification.reload.is_read).to eq true
    end
  end

  def json
    ActiveSupport::JSON.decode(response.body)
  end
end
