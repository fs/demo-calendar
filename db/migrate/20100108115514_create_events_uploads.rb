class CreateEventsUploads < ActiveRecord::Migration
  def self.up
    create_table :events_uploads do |t|
      t.integer :event_id
      t.integer :upload_id
    end
  end

  def self.down
    drop_table :events_uploads
  end
end
