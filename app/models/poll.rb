class Poll < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  has_many :options, -> { order(position: :asc) },
           dependent: :restrict_with_error
  has_many :votes, through: :options

  validates_uniqueness_of :title
  validates_presence_of :title, :user, :status
  enumerize :status, in: %i(draft open closed), default: :draft

  scope :is_open, -> { where(status: :open) }
  scope :is_closed, -> { where(status: :closed) }
  scope :is_drart, -> { where(status: :draft) }

  before_save :set_event_dates, if: :status_changed?

  def open?
    status == :open
  end

  def closed?
    status == :closed
  end

  def draft?
    status == :draft
  end

  def ready?
    options.count > 1
  end

  private

  def set_event_dates
    self.open_date = Time.now if status == :open
    self.close_date = Time.now if status == :closed
    true
  end
end
