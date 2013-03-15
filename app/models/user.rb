# coding: utf-8
class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :nickname, :image, :email, :location, :token, :secret, :slug

  has_many :plans,          :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :favorites,      :dependent => :destroy
  has_many :cheers,         :dependent => :destroy
  has_many :entries,        :dependent => :destroy
  has_many :feeds,          :dependent => :destroy
  has_many :participations, :dependent => :destroy

  # Friendly ID
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  # バリデーション
  validate :slug, uniqueness: { case_sensitive: false }

  # コールバック
  before_save { |u|
    if u.nickname.blank?
      u.nickname = u.uid
      u.slug     = u.uid
    end
  }

  #-------------#
  # auth_update #
  #-------------#
  def auth_update( auth )
    image_path = "https://graph.facebook.com/#{auth['info']['nickname'].presence || auth["uid"]}/picture?width=200&height=200"

#    puts "[ ---------- auth ---------- ]" ; auth["extra"]["raw_info"]["gender"].tapp ;

    if self.gender.blank? or self.name != auth["info"]["name"] or self.nickname != auth["info"]["nickname"] or self.image != image_path or self.email != auth["info"]["email"] or self.location != auth["info"]["location"]
      self.name     = auth["info"]["name"]
      self.nickname = auth["info"]["nickname"]
      self.image    = image_path
      self.email    = auth["info"]["email"]
      self.location = auth["info"]["location"]
      self.gender   = auth["extra"]["raw_info"]["gender"]
      self.save
    end
  end

  private

  #---------------------------#
  # self.create_with_omniauth #
  #---------------------------#
  def self.create_with_omniauth( auth )
    user = User.new
    user.provider = auth["provider"]
    user.uid      = auth["uid"]

    unless auth["info"].blank?
      user.name     = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.image    = auth["info"]["image"]
      user.email    = auth["info"]["email"]
      user.location = auth["info"]["location"]
    end

    unless auth["credentials"].blank?
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save

    return user
  end
end
