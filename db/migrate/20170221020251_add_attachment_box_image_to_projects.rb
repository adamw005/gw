class AddAttachmentBoxImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :box_image
    end
  end

  def self.down
    remove_attachment :projects, :box_image
  end
end
