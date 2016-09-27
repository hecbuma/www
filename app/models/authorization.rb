class Authorization < ActiveRecord::Base

  belongs_to :user, autosave: true, inverse_of: :authorization

  serialize :credentials, HashWithIndifferentAccess
  serialize :extra,       HashWithIndifferentAccess
  serialize :info,        HashWithIndifferentAccess

  validate              :github_authorization, if: -> { provider == 'github' }
  validates_presence_of :provider, :uid
  validates_presence_of :user, on: :update

  def self.create_by_omniauth(hash)
    user = User.find_or_initialize_by(hash[:info].slice(:name, :email))
    create(hash.merge(user: user).with_indifferent_access)
  end

  def self.find_by_omniauth(hash)
    find_by(hash.slice(:provider, :uid))
  end

  def self.find_or_create_by_omniauth(hash)
    find_by_omniauth(hash) || create_by_omniauth(hash)
  end

  def photo_url(size = 200)
    "#{info[:image]}?size=#{size}" if info && info[:image]
  end

  private

  def github_authorization
    @github_auth = GithubAuthorization.new(info[:nickname])
    unless @github_auth.valid?
      errors.add :github_authorization, @github_auth.humanized_errors
    end
  end

end
