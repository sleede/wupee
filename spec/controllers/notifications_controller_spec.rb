require 'rails_helper'

RSpec.describe API::NotificationsController, type: :controller do
  let(:notification) { create :notification }

  before :each do
    allow_any_instance_of(API::NotificationsController).to receive(:current_user).and_return(notification.receiver)
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
      expect(json[0]['message']['title']).to eq notification.notification_type
    end
  end

  describe 'GET show json' do
    render_views

    it "should returns a notification from a rendered template" do
      get :show, format: :json, id: notification.id
      expect(json['id']).to eq notification.id
      expect(json['message']['title']).to eq notification.notification_type
    end
  end

  describe 'PUT update' do
    render_views

    it "should mark as read" do
      put :update, format: :json, id: notification.id
      expect(json['is_read']).to eq true
    end
  end

  describe 'PUT update_all' do
    render_views

    it "should all notification of user mark as read" do
      put :update_all, format: :json
      expect(notification.reload.is_read).to eq true
    end
  end

  def json
    ActiveSupport::JSON.decode(response.body)
  end
end
