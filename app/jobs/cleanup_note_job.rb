class CleanupNoteJob < ApplicationJob
  queue_as :default

  def perform(id)
    Note.find(id).destroy
  end
end
